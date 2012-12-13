class Didh.Models.Text extends Backbone.Model
	paramRoot: 'text'

	initialize: ->
		collection = new Didh.Collections.AnnotationsCollection([], @)
		@set({annotations: collection})

	parse: (data) ->
		annotationsData = data['annotations']
		@get('annotations').reset(annotationsData)
		delete data['annotations']
		data

	getAuthorsList: ->
		names = (author.name for author in @.get('authors'))
		names.join(', ')


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