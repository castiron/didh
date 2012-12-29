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

	getKeyword: (sentenceId) ->
		keywords = @get('keywords_grouped')
		keyword = _.find(keywords, (keyword) ->
			parseInt(keyword.sentence) == parseInt(sentenceId)
		)

	getAnnotatedSentenceCount: () ->
		count = @get('sentences').length

	getIndexedSentencesCount: () ->
		count = @get('keywords_grouped').length

	getAnnotationCount: () ->
		count = _.reduce(@get('sentences'), (memo, num) ->
			memo + parseInt num.count
		, 0)

	getTotalMarkedAndIndexed: () ->
		all = @get('sentences').concat(@get('keywords_grouped'))
		count = _.reduce(all, (memo, num) ->
			memo + parseInt num.count
		, 0)

	getIndexedCount: () ->
		count = _.reduce(@get('keywords_grouped'), (memo, num) ->
			memo + parseInt num.count
		, 0)

	getAnnotationCountFor: (sentenceId) ->
		sentence = @getSentence(sentenceId)
		if sentence?
			sentence.count

	incrementGroupedKeywordCount: (sentenceId) ->
		keywords = @get('keywords_grouped')
		console.log keywords, 'before'
		keyword = @getKeyword(sentenceId)
		console.log keyword,' a'
		if keyword?
			keyword.count++
		else
			keywords.push({keyword: sentenceId, count: 1})
		@set('keywords_grouped', keywords)

		console.log @get('keywords_grouped'), 'after'

		@trigger('change:keywords_grouped')

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