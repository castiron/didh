Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.AnnotatorView extends Backbone.View
	template: JST["backbone/templates/frontend/annotator"]

	events: 
		'click .annotate-close'			: 'stopAnnotating'
		'click .annotate-interesting'	: 'annotateInteresting'
		'click .annotate-index'			: 'annotateIndex'

	initialize: () ->
		@currentSentenceId = null
		@parts = @options.parts
		@annotations = @options.annotations
		@texts = @options.texts
		@router = @options.router

	calculateAnnotatorLocationFor: (sentenceEl, event) ->
		clickX = event.pageX
		clickY = event.pageY
		position = {top: (clickY - @$el.height() - 40)+ 'px', left: (clickX - 43) + 'px'}

	showAnnotatorOn: (sentenceEl, event) ->
		@stopAnnotating()
		@currentSentenceEl = $(sentenceEl)
		@currentSentenceId = @currentSentenceEl.attr('data-id')
		@currentSentenceEl.addClass('hover')
		@$el.css(@calculateAnnotatorLocationFor(sentenceEl, event))

		# Render the sucker
		@render()

		# Then apply any effects
		@$el.fadeIn(75, =>
			@$el.find('.js-right').animate({ left: 316}, 250)
		)

	stopAnnotating: (e) ->
		@$el.hide()
		if @currentSentenceEl? then @currentSentenceEl.removeClass('hover')
		@currentSentenceEl = null
		@currentSentenceId = null

	annotateInteresting: (e) ->
		activeText = @texts.getActiveText()
		annotation = new Didh.Models.Annotation({
			sentence: @currentSentenceId
			text_id: activeText.id
		})
		annotation.save({}, {
			success: =>
				activeText.incrementAnnotationCount(@currentSentenceId)
				@stopAnnotating()
			error: ->
				@stopAnnotating()
		})

	annotateIndex: (e) ->

	render: =>
		$(@el).html(@template({text: @texts.getActiveText(), sentenceId: @currentSentenceId}))
		return @
