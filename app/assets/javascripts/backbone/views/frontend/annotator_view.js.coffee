Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.AnnotatorView extends Backbone.View
	template: JST["backbone/templates/frontend/annotator"]

	events: 
		'click .annotate-close'			: 'stopAnnotating'
		'click .annotate-interesting'	: 'annotateInteresting'
		'click .annotate-index'			: 'annotateIndex'
		'submit #annotate-index-form'	: 'createIndexKeyword'

	initialize: () ->
		@annotatorHeight = 0
		@currentSentenceId = null
		@parts = @options.parts
		@keywords = @options.keywords
		@annotations = @options.annotations
		@texts = @options.texts
		@router = @options.router

	calculateAnnotatorLocationFor: (sentenceEl, event) ->
		# We only set the height once, on the first appearance, and then treat it as constant.
		# We do this so that the changing height of the annotator doesn't mess up the position.
		if @annotatorHeight == 0 then @annotatorHeight = @$el.height()
		clickX = event.pageX
		clickY = event.pageY
		console.log @$el.height()
		position = {top: (clickY - @annotatorHeight - 40)+ 'px', left: (clickX - 43) + 'px'}

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
		# TODO: Set focus on the input
		@$el.find('.annotate-index-input').first().slideDown()
		@$el.find('.annotate-index-input input').focus()
	
	createIndexKeyword: (e) ->
		word = @$el.find('.annotate-index-input input').first().val()
		if !word
			@$el.find('.annotate-index-input input').first().effect("shake", { times:2, distance: 5}, 50);
		else
			keyword = new Didh.Models.Keyword({
				sentence: @currentSentenceId
				word: word
				text_id: @texts.getActiveText().id
			})
			keyword.save({})
			@stopAnnotating()
		false

	render: =>
		$(@el).html(@template({text: @texts.getActiveText(), sentenceId: @currentSentenceId}))
		return @
