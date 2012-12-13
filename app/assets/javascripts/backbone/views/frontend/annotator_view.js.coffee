Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.AnnotatorView extends Backbone.View
	template: JST["backbone/templates/frontend/annotator"]

	events: 
		'click .annotate-close'			: 'stopAnnotating'
		'click .annotate-interesting'	: 'annotateInteresting'
		'click .annotate-index'			: 'annotateIndex'

	initialize: () ->
		@isVisible = false
		@currentSentenceId = null
		@parts = @options.parts
		@texts = @options.texts
		@router = @options.router
		@render()

	calculateAnnotatorLocationFor: (sentenceEl, event) ->
		clickX = event.pageX
		$sentenceEl = $(sentenceEl)
		sentenceElPosition = $sentenceEl.position()
		sentenceElOffset = $sentenceEl.offset()
		moveTo = {top: sentenceElPosition.top - @$el.height() - 10, left: clickX - sentenceElOffset.left - 10}
		position = {top: moveTo.top + 'px', left: moveTo.left + 'px'}

	showAnnotatorOn: (sentenceEl, event) ->
		if @isVisible = true then @stopAnnotating()
		@$el.css(@calculateAnnotatorLocationFor(sentenceEl, event))
		@currentSentenceId = $(sentenceEl).attr('data-id')
		@$el.fadeIn()

	stopAnnotating: (e) ->
		@$el.hide()
		@currentSentenceId = null

	annotateInteresting: (e) ->
		annotations = @texts.getActiveText().get('annotations')
		annotation = _.first(annotations.where({sentence: parseInt(@currentSentenceId)}))
		if annotation?
			annotation.incrementCount()
		else
			annotation = new Didh.Models.Annotation({sentence: parseInt(@currentSentenceId), count: 0})
			annotations.add(annotation)
			annotation.incrementCount()
		@stopAnnotating()

	annotateIndex: (e) ->
		console.log @currentSentenceId

	render: =>
		$(@el).html(@template())
		return @
