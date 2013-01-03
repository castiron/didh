namespace :texts do

	desc "Tasks relating to text imports"

	task :import, [:files] => [:environment] do |t, args|
		args.with_defaults(:files => './texts')
		if File.directory?(args[:files])
			puts "[info] found directory: #{args[:files]}"
			Dir["#{args[:files]}/*.html"].each do |file|
				importOneText(file)
			end
		elsif File.file?(args[:files])
			puts "[info] found file: #{args[:files]}"
			file = File.open(args[:files])
			importOneText(file)
		else
			puts "[error] file not found: #{args[:files]}"
		end
	end

	# One of the weakest parts of the app, and the first that was written.
	# Some day, when there's time, this whole process should be broken up
	# and made less procedural. When this was written, it was mainly as
	# a proof of concept to see if Nokogiri could cleanly parse these docs
	# and if the Stanford Natural Language Processor (SNLP) would be sufficient
	# for chunking the texts into sentences. The POC became the engine, and
	# there hasn't yet been time to revisit it --ZD
	def importOneText(file)
		puts "[#{file}] [info] importing #{file}"
		fileBasename = File.basename(file)
		htmlDoc = Nokogiri::HTML(File.open(file))

		# Get the title
		sorting = fileBasename.gsub(/[^0-9]/, '')
		title = htmlDoc.css("p.ct span").inner_html
		puts "[#{file}] [info] found title: #{title}"

		# auto-assign texts to parts.
		part = htmlDoc.css("p.cn span a").inner_html
		puts "[#{file}] [info] found part: #{part}"
		if part.include? "Introduction" then
			part_num = 0
		end
		if part.include? "PART I" then
			part_num = 1
		end
		if part.include? "PART II" then
			part_num = 2
		end
		if part.include? "PART III" then
			part_num = 3
		end
		if part.include? "PART IV" then
			part_num = 4
		end
		if part.include? "PART V" then
			part_num = 5
		end
		if part.include? "PART VI" then
			part_num = 6
		end
		part = Part::where(:sorting => part_num).first

		# assign texts to the correct edition
		edition = Edition.first


		# Handle the authors string
		authorString = htmlDoc.css("p.au span").inner_html
		authors = authorString.gsub(/ AND /i, ",").split(",").map(&:strip).reject(&:empty?)
		authorsArray = []
		authors.each do |author|
			if Author.where(:name => author).count > 0
				authorsArray << Author.where(:name => author).first
			else
				author = Author.new(:name => author)
				author.save
				authorsArray << author
			end
		end

		puts "[#{file}] [info] found authors: #{authorsArray}"

		# Get the body text
		body = String.new

		startNodePath = "//div[@class='epigraph'] | //p[@class='pf' or @class='paft' or @class='ah']"

		body = body + htmlDoc.at_xpath(startNodePath).to_html
		puts "[#{file}] [info] found body"
		node = htmlDoc.at_xpath(startNodePath).next_sibling
		bodyStopNode = htmlDoc.at_xpath("//div[@class='hanging']")
		while node && node != bodyStopNode
			body = body + node.to_html unless node.type == 3 # skip text nodes
			node = node.next_sibling
		end

		# Begin natural language parsing
		StanfordCoreNLP.log_file = '/dev/null'
		StanfordCoreNLP.jar_path = "#{Rails.root}/lib/vendor/snlp/"
		StanfordCoreNLP.model_path = "#{Rails.root}/lib/vendor/snlp/"
		pipeline = StanfordCoreNLP.load(:tokenize, :ssplit)

		i = 0
		bodyDoc = Nokogiri::HTML(body)
		bodyDoc.xpath('//*[self::div or self::p or self::blockquote or self::a]').each do |node|
			chunk = node.inner_html
			chunk.gsub! /<span[^>]*>/, ''
			chunk.gsub! /<\/span>/, ''

			chunkNLP = StanfordCoreNLP::Text.new(chunk)
			pipeline.annotate(chunkNLP)
			chunkNLP.get(:sentences).each do |sentence|
				i = i + 1
				sentenceString = sentence.to_s
				sentenceString.sub! /^\d{1,3}<\/sup><\/a>/, ''
				if sentenceString.length > 5 && !sentenceString.start_with?('http') && !sentenceString.start_with?('www.')
					checksum = sentenceString.to_s.sum
					replacementSentence = "<span class=\"sentence\" data-id=\"#{checksum}\" id=\"sentence-#{checksum}\">#{sentenceString}</span>"
					res = body.sub! sentenceString, replacementSentence

					if res == nil
					end
				end
				i
			end
		end
		puts "[#{file}] [info] found #{i} sentences"

		# Fix all image paths
		imageSources = htmlDoc.css('img').map { |i| i['src'] }
		imageSources.each do |source|
			puts "[#{file}] [info] transformed image #{source} into /#{source}"
			body.sub! source, "/#{source}"
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
			notes = notes + noteNodes.to_html
			puts "[#{file}] [info] found #{noteNodes.length} endnote nodes"
		end

		# Check for an existing text to update, otherwise create a new text.
		existingText = Text.where(:source_file => fileBasename).first

		if existingText != nil
			puts "[#{file}] [info] updating existing text"
			text = existingText
		else
			puts "[#{file}] [info] creating a new text"
			text = Text.new
		end

		# Set the text object's attributes.
		text.attributes = {
				:title => title,
				:sorting => sorting,
				:body => body,
				:authors => authorsArray,
				:notes => notes,
				:bibliography => bibliography,
				:source_file => fileBasename
		}

		text.edition = edition
		text.part = part
		text.save


	end

end