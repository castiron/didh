class Didh.Routers.AppRouter extends Backbone.Router
	initialize: (options) ->


		$(document).on "click", "a[href^='/debates/']", (event) =>
			href = $(event.currentTarget).attr('href')
			if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
				event.preventDefault()

				# Remove root part of the URL and hash bangs (backward compatablility)
				url = href.replace(/^\/debates/,'').replace('\#\!\/','')

				# Instruct Backbone to trigger routing events
				@navigate url, { trigger: true }

				return false

		$(document).on "click", "a[href^='#']", (event) =>
			href = $(event.currentTarget).attr('href')
			if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
				anchor = href.replace(/^#/,'');
				$('html, body').animate({scrollTop: $('#' + anchor).offset().top - 100}, 250)
				return false


		@parts = new Didh.Collections.PartsCollection()
		@parts.reset options.parts
		@texts = new Didh.Collections.TextsCollection()
		@texts.reset options.texts
		@annotations = new Didh.Collections.AnnotationsCollection()
		@annotations.reset options.annotations
		@keywords = new Didh.Collections.KeywordsCollection()

		@annotator = new Didh.Views.Frontend.AnnotatorView(el: $("#backbone-annotatorView"), keywords: @keywords, annotations: @annotations, parts: @parts, texts: @texts, router: @ )
		@banner= new Didh.Views.Frontend.BannerView(el: $("#backbone-bannerView"), router: @ )
		@banner= new Didh.Views.Frontend.HudView(el: $("#backbone-hudView"), texts: @texts, router: @ )

		# The two views are linked, and need to be able to trigger open and closing on one another.
		@tocView = new Didh.Views.Frontend.TocView(el: $("#backbone-tocView"), parts: @parts, texts: @texts, router: @ )
		@feedbackView = new Didh.Views.Frontend.FeedbackView(el: $("#backbone-feedbackView"), linkedPane: @tocView, texts: @texts, router: @ )
		@tocView.linkedPane = @feedbackView

		@tocView.render()
		@annotator.render()

	routes:
		"part/:id"			: "showPart"
		"text/:id"			: "showText"
		"*catchall"					: "setDefaultText" # Backbone, wtf does this work?

	setDefaultText: () ->
		part = _.first(@parts.where({label: "Introduction"}))
		text = _.first(@texts.where({part: part.id}))
		@setActiveText(text.id)

	renderTextView: () ->
		@textView.render()

	showText: (textId) ->
		@tocView.goToPosition(1)
		@feedbackView.goToPosition(1)
		@setActiveText(textId)

	updateVisualizationType: (type) ->
		@textView.updateVisualizationType(type)

	setActiveText: (id) ->
		id = parseInt(id)
		@requestedTextId = id
		text = @texts.get(id)

		# Don't set the active text if the requested text is the same as the active text
		if id != @texts.getActiveTextId()
			if text.get('isLoaded')
				@texts.setActiveText(text.get('id'))
				@feedbackView.setModel(text)
				@feedbackView.render()
				@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), model: text, visualization: @feedbackView.getVisualizationType(), parts: @parts, texts: @texts, annotator: @annotator, router: @ )
				@textView.render()
			else
				text.fetch({
					success: =>
						@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), model: text, visualization: @feedbackView.getVisualizationType(), parts: @parts, texts: @texts, annotator: @annotator, router: @ )
						@texts.setActiveText(text.get('id'))
						@feedbackView.setModel(text)
						text.set({isLoaded: true})
				})
			@parts.setActivePart(text.get('part'))

	showPart: (id) ->
		@annotator.stopAnnotating()
		part = @parts.get(id)
		if !@texts.getActiveTextId()
			@requestedPartId = id
			text = _.first(@texts.where({part: part.id}))
			@setActiveText(text.id)

		@tocView.showPart(part)

	getRequestedText: () ->
		if @requestedTextId?
			@texts.get(@requestedTextId)
		else
			return null

	init: ->

