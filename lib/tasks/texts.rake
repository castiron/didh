namespace :texts do

  desc 'test'
  task :test_java do |t, args|
    require 'rjb'
    Point = Rjb::import('java.awt.Point')
#		p = Point.new(0, 0)
#		p.y = 80
#		puts "x=#{p.x}, y=#{p.y}" # => "0,80"
  end

  desc "Tasks relating to text imports"
  # EG: bundle exec rake texts:import[./texts/ump-gold0014.html] to import one text or just bundle exec rake texts:import to import all texts in ./texts
  task :import, [:files] => [:environment] do |t, args|
    confirm_editions_exist
    confirm_parts_exist

    args.with_defaults(:files => './texts/editions')
    if File.directory?(args[:files])
      puts "[info] found directory: #{args[:files]}"
      Dir["#{args[:files]}/*"].each.with_index(1) do |file, index|
        if File.directory?(file)
          puts "[info] found directory: #{file}"
          /\/([1-9])$/.match(file)
          edition_id = $1
          raise "Can't figure out the edition based on the import file path" if edition_id.blank?

          xml_files = Dir["#{file}/*.html", "#{file}/*.xhtml"]

          # Order by filename-terminal number
          xml_files.sort_by { |f| /(?<=[^0-9])[0-9]+(?=\.x?html)/.match(f).to_s.to_i }.each do |textFile|
            puts "[info] found file: #{textFile}"
            importOneText(textFile, edition_id)
          end
        end
      end
    else
      puts "[error] file not found: #{args[:files]}"
    end
  end

  def confirm_editions_exist
    raise "Editions don't exist; please run `rake db:seed`" if Edition.count == 0
  end

  def confirm_parts_exist
    raise "Parts don't exist; please run `rake db:seed`" if Part.count == 0
  end

  # In the first edition, all chapters were prepending with the part number. Not so in the 2nd.
  def get_first_edition_part_from_string(part_string)
    if part_string.include? "Introduction" then
      part_num = 0
    end
    if part_string.include? "PART I" then
      part_num = 1
    end
    if part_string.include? "PART II" then
      part_num = 2
    end
    if part_string.include? "PART III" then
      part_num = 3
    end
    if part_string.include? "PART IV" then
      part_num = 4
    end
    if part_string.include? "PART V" then
      part_num = 5
    end
    if part_string.include? "PART VI" then
      part_num = 6
    end
    if part_num
      Part.where(:sorting => part_num, edition_id: 1).first
    else
      nil
    end
  end

  # In the second edition EPUB, the part is determined by a part title page, which would be an ugly departure from
  # the way it's happening for the first edition. Thus, hard-codey.
  def get_second_edition_part_from_file(file)
    /-([0-9]+)\.xhtml$/.match(file)
    file_num = $1.to_i

    if file_num < 7
      return Part.where(edition_id: 2, label: "Introduction").first
    end
    if file_num < 16
      return Part.where(edition_id: 2, label: "Histories and Futures of the Digital Humanities").first
    end

    if file_num < 26
      return Part.where(edition_id: 2, label: "Digital Humanities and Its Methods").first
    end

    if file_num < 34
      return Part.where(edition_id: 2, label: "Digital Humanities and Its Practices").first
    end

    if file_num < 43
      return Part.where(edition_id: 2, label: "Digital Humanities and the Disciplines").first
    end

    if file_num < 53
      return Part.where(edition_id: 2, label: "Digital Humanities and Its Critics").first
    end

    if file_num < 63
      return Part.where(edition_id: 2, label: "Forum: Text Analysis at Scale").first
    end

    if file_num < 65
      return Part.where(edition_id: 2, label: "Series Introduction and Editors’ Note").first
    end

    nil
  end

  # One of the weakest parts of the app, and the first that was written.
  # Some day, when there's time, this whole process should be broken up
  # and made less procedural. When this was written, it was mainly as
  # a proof of concept to see if Nokogiri could cleanly parse these docs
  # and if the Stanford Natural Language Processor (SNLP) would be sufficient
  # for chunking the texts into sentences. The POC became the engine, and
  # there hasn't yet been time to revisit it --ZD
  def importOneText(file, edition)
    puts "[#{file}] [info] importing #{file}"
    fileBasename = File.basename(file)
    htmlDoc = Nokogiri::HTML(File.open(file))

    # Get the title
    # Accommodating different structures when implementing 2nd edition
    sorting = fileBasename.gsub(/[^0-9]/, '')
    title = htmlDoc.css("p.ct span").inner_html
    title = htmlDoc.css("h1.ct").inner_html if title.blank?
    title = htmlDoc.css("h1.ctfm").inner_html if title.blank?
    title = ActionView::Base.full_sanitizer.sanitize(title)

    puts "[#{file}] [info] found title: #{title}"

    # auto-assign texts to parts.
    part_string = htmlDoc.css("p.cn span a").inner_html


    if edition == "1"
      part = get_first_edition_part_from_string(part_string)
    elsif edition == "2"
      part = get_second_edition_part_from_file(file)
    end

    puts "[#{file}] [info] found part: #{part.label}" unless part.blank?

    #use the index of the dir holding the text to assign the edition;
    #defaults to first edition it can find it not dirIndex was passed in (i.e. assumes edition dirs are in sequential order)

    if edition then
      edition = Edition.find_by id: edition
    else
      raise "Don't know what edition to assign these texts to!"
    end

    puts "[#{file}] [info] found edition #{edition.label}"

    # Handle the authors string
    # Accommodating different structures when implementing 2nd edition
    authorString = htmlDoc.css("p.au span").inner_html
    authorString = htmlDoc.css("p.au").inner_html if authorString.blank?

    # Note: upcasing author names in order to make 2nd edition names consistent with 1st ed
    authors = authorString.gsub(/ AND /i, ",").split(",").map(&:strip).reject(&:empty?).map(&:upcase)
    authorsOrdered = []
    authors.each do |author|
      if Author.where(:name => author).count > 0
        authorsOrdered << Author.where(:name => author).first
      else
        author = Author.new(:name => author)
        author.save
        authorsOrdered << author
      end
    end

    puts "[#{file}] [info] found authors: #{authorsOrdered}"

    # Get the body text
    body = String.new
    startNodePath = "//div[@class='epigraph'] | //p[@class='pf' or @class='paft' or @class='ah'] | //h2[@class='ahaft']"
    node = htmlDoc.at_xpath(startNodePath)

    if node.nil?
      puts "[#{file}] No content found using xpath: #{startNodePath}"
    else
      body = body + node.to_html
      puts "[#{file}] [info] found body"
      node = htmlDoc.at_xpath(startNodePath).next_sibling
      bodyStopNode = htmlDoc.at_xpath("//div[@class='hanging'] | //div[@class='chapter']/p[last()]/following-sibling::*")
      while node && node != bodyStopNode
        body = body + node.to_html unless node.type == 3 # skip text nodes
        node = node.next_sibling
      end

      endnote_href_regex = /href="#{Regexp.escape(File.basename(file))}(#[^"]+)"/
      body.gsub!(endnote_href_regex, 'href="\1"')

      dropcap_span_regex = /#{Regexp.escape('<span class="dropcap">') + '(\S)' + Regexp.escape('</span>')}/
      body.gsub!(dropcap_span_regex, '\1')

      # Begin natural language parsing
      StanfordCoreNLP.log_file = "#{Rails.root}/log/snlp.log"
      StanfordCoreNLP.jar_path = "#{Rails.root}/lib/vendor/snlp/"
      StanfordCoreNLP.model_path = "#{Rails.root}/lib/vendor/snlp/"
      pipeline = StanfordCoreNLP.load(:tokenize, :ssplit)
      i = 0

      # Check for an existing text to update, otherwise create a new text.
      existingText = Text.where(:source_file => fileBasename).first

      if existingText != nil
        puts "[#{file}] [info] updating existing text"
        text = existingText
      else
        puts "[#{file}] [info] creating a new text"
        text = Text.new
      end

      sentences = []

      bodyDoc = Nokogiri::HTML(body)
      bodyDoc.xpath('//*[self::div or self::p or self::blockquote or self::a]').each do |node|
        chunk = node.inner_html
        chunk.gsub! /<span[^>]*>/, ''
        chunk.gsub! /<\/span>/, ''

        chunkNLP = StanfordCoreNLP::Annotation.new(chunk)
        pipeline.annotate(chunkNLP)
        chunkNLP.get(:sentences).each do |sentence|
          sentenceString = sentence.to_s
          sentenceString.sub! /^\d{1,3}<\/sup><\/a>/, ''
          if sentenceString.length > 5 && !sentenceString.start_with?('http') && !sentenceString.start_with?('www.')
            i = i + 1
            checksum = sentenceString.to_s.sum
            sentenceModel = Sentence.find_or_create_by(:checksum => checksum, :text_id => text.id)
            sentenceModel.body = sentenceString
            replacementSentence = "<span class=\"sentence\" data-id=\"#{checksum}\" id=\"sentence-#{checksum}\">#{sentenceString}</span>"
            res = body.sub! sentenceString, replacementSentence
            sentences << sentenceModel
          end
          i
        end
      end

      # Fix all image paths
      imageSources = htmlDoc.css('img').map { |i| i['src'] }
      imageSources.each do |source|
        source_filename = File.basename(source)
        target = "/images/editions/#{edition.id}/#{source_filename}"
        puts "[#{file}] [info] transformed image #{source} into #{target}"
        body.sub! source, target
      end

      bibliographyNodes = htmlDoc.css("p.rf")
      bibliography = bibliographyNodes.to_html

      puts "[#{file}] [info] found #{bibliographyNodes.length} bibliography nodes"

      notes = String.new
      notesPreface = htmlDoc.at_xpath("//p[@class='enp']")
      if notesPreface != nil
        notes = notesPreface.to_html
        puts "[#{file}] [info] found endnote preface: #{notes[0, 60]}..."
      end

      # TODO: This is missing div.list in the notes section.
      noteNodes = htmlDoc.xpath("//p[@class='en']")
      if noteNodes != nil
        noteNodes.xpath("a[@class='ennum']").each do |tag|
          tag.set_attribute('href', tag['href'].match('(#.*)').try(:[],1)) if !tag['href'].nil?
        end
        notes = notes + noteNodes.to_html
        puts "[#{file}] [info] found #{noteNodes.length} endnote nodes"
      end

      authorsTexts = []
      i = 0
      authorsOrdered.each do |author|
        i = i + 1
        at = AuthorsText.new(author: author, sorting: i)
        authorsTexts << at
      end

      # Set the text object's attributes.
      text.attributes = {
          :edition => edition,
          :title => title,
          :sorting => sorting,
          :body => body,
          :notes => notes,
          :bibliography => bibliography,
          :source_file => fileBasename
      }

      text.edition = edition
      text.part = part
      text.save

      i = 0
      authorsOrdered.each do |author|
        at = AuthorsText.where(author: author, text: text).first
        if !at
          at = AuthorsText.new(author: author, sorting: i, text: text)
          at.save
        end

        i = i + 1
      end

      sentences.each do |sentence|
        sentence.save()
      end
    end
  end
end
