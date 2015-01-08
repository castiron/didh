atom_feed do |feed|
  if @text
    feed.title(@text.title)
  else
    feed.title('DH Debates Comment Feed')
  end
  feed.updated(@comments[0].created_at) if @comments.length > 0

  @comments.each do |comment|
    feed.entry(comment, :url => '/') do |entry|
      entry.title('Posted ' + comment.calculate_age())
      entry.content(comment.body, type: 'html')
      entry.author(comment.screen_name)
      entry.url("http://#{@hostname}/debates/text/#{comment.text_id}/comment/#{comment.sentence_checksum}##{comment.id}")
    end
  end
end