class Didh.Routers.AppRouter extends Backbone.Router
	initialize: (options) ->
		@parts = new Didh.Collections.PartsCollection()
		@parts.reset options.parts
		@texts = new Didh.Collections.TextsCollection()
		@texts.reset options.texts
		@annotations = new Didh.Collections.AnnotationsCollection()
		@annotations.reset options.annotations
		@keywords = new Didh.Collections.KeywordsCollection()

		@annotator = new Didh.Views.Frontend.AnnotatorView(el: $("#backbone-annotatorView"), keywords: @keywords, annotations: @annotations, parts: @parts, texts: @texts, router: @ )
		@tocView = new Didh.Views.Frontend.TocView(el: $("#backbone-tocView"), parts: @parts, texts: @texts, router: @ )
		@tocView.render()
		#@textView.render()

	routes:
		"text/:textId/part/:partId"	: "showPartAndText"
		"part/:id"					: "showPart"
		"text/:id"					: "showText"
		"*catchall"					: "setDefaultText" # Backbone, wtf does this work?

	showPartAndText: (textId, partId) ->
		@requestedTextId = textId
		@requestedPartId = partId
		@setActiveText(textId)
		@showPart(partId)

	setDefaultText: () ->
		@setActiveText(1)

	renderTextView: () ->
		@textView.render()

	showText: (textId) ->
		@tocView.closePane()
		@setActiveText(textId)

	setActiveText: (id) ->
		id = parseInt(id)
		@requestedTextId = id
		text = @texts.get(id)

		# Don't set the active text if the requested text is the same as the active text
		if id != @texts.getActiveTextId()
			if text.get('isLoaded')
				@texts.setActiveText(text.get('id'))
				@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), model: text, parts: @parts, texts: @texts, annotator: @annotator, router: @ )
				@textView.render()
			else
				text.fetch({
					success: =>
						@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), model: text, parts: @parts, texts: @texts, annotator: @annotator, router: @ )
						@texts.setActiveText(text.get('id'))
						text.set({isLoaded: true})
				})
			@parts.setActivePart(text.get('part'))

	showPart: (id) ->
		@annotator.stopAnnotating()
		@requestedPartId = id
		@tocView.showPart(@parts.get(id))

	getRequestedText: () ->
		if @requestedTextId?
			@texts.get(@requestedTextId)
		else
			return null

	init: ->

