namespace :texts do

	desc "Tasks relating to text imports"

	task :import => :environment do
		abort
		files = "./texts"
	    Dir["#{files}/*.html"].each do |file|
	    	#importOneText(file)
	    end
	end

	def importOneText(file)
		puts "importing #{file}"
		fileHandle = File.open(file)
    	htmlDoc = Nokogiri::HTML(fileHandle)

    	title = htmlDoc.css("p.ct span").inner_html
    	puts "   found title: #{title}"
    	authors = htmlDoc.css("p.au span").inner_html
    	puts "   found authors: #{authors}"

    	body = String.new
    	body = body + htmlDoc.at_xpath("//p[@class='pf' or @class='paft']").to_html
    	puts "   found body: #{body[0,60]}..."
    	node = htmlDoc.at_xpath("//p[@class='pf' or @class='paft']").next_sibling
		bodyStopNode = htmlDoc.at_xpath("//div[@class='hanging']")
		while node && node != bodyStopNode
			body = body + node.to_html unless node.type == 3 # skip text nodes
			node = node.next_sibling
		end

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

	    text = Text.new(:title => title, :body => body, :notes => notes, :bibliography => bibliography)
	    text.save

	end

end