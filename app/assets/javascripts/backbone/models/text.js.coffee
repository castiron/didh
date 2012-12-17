class Didh.Models.Text extends Backbone.Model
	paramRoot: 'text'

	initialize: ->

	parse: (data) ->
		_.each(data.sentences, (sentence) ->
			sentence.count = parseInt(sentence.count)
		)
		data

	getAuthorsList: ->
		names = (author.name for author in @.get('authors'))
		names.join(', ')

	getSentence: (sentenceId) ->
		sentences = @get('sentences')
		sentence = _.find(sentences, (sentence) -> 
			parseInt(sentence.sentence) == parseInt(sentenceId)
		)

	getAnnotatedSentenceCount: () ->
		count = @get('sentences').length

	getAnnotationCount: () ->
		count = _.reduce(@get('sentences'), (memo, num) -> 
			memo + parseInt num.count
		, 0)
		

	getAnnotationCountFor: (sentenceId) ->
		sentence = @getSentence(sentenceId)
		if sentence?
			sentence.count

	incrementAnnotationCount: (sentenceId) ->
		sentences = @get('sentences')
		sentence = @getSentence(sentenceId)
		if sentence?
			sentence.count++
		else
			sentences.push({sentence: sentenceId, count: 1})
		@set({'sentences', sentences})
		@trigger('change:sentences')

class Didh.Collections.TextsCollection extends Backbone.Collection
	model: Didh.Models.Text
	url: '/texts'

	getActiveTextId: () ->
		activeText = @getActiveText()
		if activeText?
			activeText.id
		else
			null

	getActiveText: () ->
		activeText = _.first(@.where({active: true}))

	setActiveText: (textId) ->
		@getActiveText()
		if activeText?
			activeTextId = activeText.get('id')
		else
			activeTextId = 0
		if activeTextId != textId
			_.each(@.where({active: true}), (text) ->
				text.set({active: false}, {silent: true} )
			)
			@.get(textId).set({active: true})

	byPartGrouped: (partId, count) ->
		texts = @where({'part': partId})
		out = new Array
		out.push new Array
		textCounter = 0
		_.each texts, (text) ->
			if textCounter == count
				out.push new Array
				textCounter = 0
			out[out.length - 1].push(text)
			textCounter++
		out