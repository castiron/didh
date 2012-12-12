class Didh.Routers.AppRouter extends Backbone.Router
	initialize: (options) ->
		@parts = new Didh.Collections.PartsCollection()
		@parts.reset options.parts
		@texts = new Didh.Collections.TextsCollection()
		@texts.reset options.texts

		@annotator = new Didh.Views.Frontend.AnnotatorView(el: $("#backbone-annotatorView"), parts: @parts, texts: @texts, router: @ )
		@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), parts: @parts, texts: @texts, annotator: @annotator, router: @ )
		@tocView = new Didh.Views.Frontend.TocView(el: $("#backbone-tocView"), parts: @parts, texts: @texts, router: @ )
		@tocView.render()
		#@textView.render()

	routes:
		"text/:textId/part/:partId"	: "showPartAndText"
		"part/:id"					: "showPart"
		"text/:id"					: "setActiveText"

	showPartAndText: (textId, partId) ->
		@requestedTextId = textId
		@requestedPartId = partId
		@setActiveText(textId)
		@showPart(partId)

	setDefaultText: () ->
		@setActiveText(1)

	setActiveText: (id) ->
		@requestedTextId = id
		text = @texts.get(id)
		if text.get('isLoaded')
			@texts.setActiveText(text.get('id'))
		else
			text.fetch({
				success: =>
					@texts.setActiveText(text.get('id'))
					text.set({isLoaded: true})
			})
		@parts.setActivePart(text.get('part'))

	showPart: (id) ->
		@requestedPartId = id
		@tocView.showPart(@parts.get(id))

	getRequestedText: () ->
		if @requestedTextId?
			@texts.get(@requestedTextId)
		else
			return null

	init: ->

