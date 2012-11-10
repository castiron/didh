namespace :texts do

	desc "Tasks relating to text imports"

	task :import => :environment do
		files = "./texts"
	    Dir["#{files}/*.html"].each do |file|
	    	importOneText(file)
	    end
	end

	def importOneText(file)
		puts "importing #{file}"
		fileBasename = File.basename(file)
    	htmlDoc = Nokogiri::HTML(File.open(file))

    	# Get the title
    	title = htmlDoc.css("p.ct span").inner_html
    	puts "   found title: #{title}"

    	# Todo: auto-assign texts to parts.
    	part = htmlDoc.css("p.cn span a").inner_html
    	puts "   found part: #{part}"

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

    	puts "   found authors: #{authorsArray}"

    	# Get the body text
    	body = String.new
    	body = body + htmlDoc.at_xpath("//p[@class='pf' or @class='paft']").to_html
    	puts "   found body: #{body[0,60]}..."
    	node = htmlDoc.at_xpath("//p[@class='pf' or @class='paft']").next_sibling
		bodyStopNode = htmlDoc.at_xpath("//div[@class='hanging']")
		while node && node != bodyStopNode
			body = body + node.to_html unless node.type == 3 # skip text nodes
			node = node.next_sibling
		end

		# Begin natural language parsing
		StanfordCoreNLP.jar_path = 		'/Users/zdavis/Development/didh/lib/vendor/snlp/'
		StanfordCoreNLP.model_path =	'/Users/zdavis/Development/didh/lib/vendor/snlp/'
		pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit)
		
		# TODO: None of these regexs are really working
#		myBody = body.dup
#		myBody.gsub! /<span[^>]*>/, ''
#		myBody.gsub! /<\/span>/, ''

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
				if sentenceString.length > 5
					checksum = sentenceString.to_s.sum

					res = body.sub! sentenceString, "<span class=\"sentence\" id=\"sentence-#{checksum}\">#{sentenceString}</span>"
					if res == nil 
					end
				end
				i
			end
		end
		puts "   found #{i} sentences"

		bibliographyNodes = htmlDoc.css("p.rf")
		bibliography = bibliographyNodes.to_html
    	puts "   found #{bibliographyNodes.length} bibliography nodes"

    	notes = String.new
    	notesPreface = htmlDoc.at_xpath("//p[@class='enp']")
    	if notesPreface != nil
    		notes = notesPreface.to_html
    		puts "   found endnote preface: #{notes[0,60]}..."
    	end
    	noteNodes = htmlDoc.xpath("//p[@class='en']")
    	if noteNodes != nil
	    	notes = notes + noteNodes.to_html
	    	puts "   found #{noteNodes.length} endnote nodes"
	    end

	    # Check for an existing text to update, otherwise create a new text.
	    existingText = Text.where(:source_file => fileBasename).first

	    if existingText != nil
	    	puts "   updating existing text"
	    	text = existingText
	    else
	    	puts "   creating a new text"
		    text = Text.new
		end

		# Set the text object's attributes.
		text.attributes = {
			:title => title, 
			:body => body, 
			:authors => authorsArray, 
			:notes => notes, 
			:bibliography => bibliography, 
			:source_file => fileBasename
		}

		text.save


	end

end