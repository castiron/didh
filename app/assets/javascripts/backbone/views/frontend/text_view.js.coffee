Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
	template: JST["backbone/templates/frontend/text"]

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@annotations = @options.annotations
		@router = @options.router
		@annotator = @options.annotator
		if @options.visualization?
			@visualization = @options.visualization
		else
			@visualization = 'none'

		@model.bind('change:isLoaded', @render, @)
		@model.bind('change:sentences', @updateAnnotations, @)

	events: 
		"click .sentence" 	: "showAnnotator"

	showAnnotator: (e) ->
		@annotator.showAnnotatorOn(e.target, e)

	showAnnotationDetail: (e) ->
		$el = $(e.target)
		$el.find('.annotation-counter').show()

	showText: (text) ->
		text = @texts.where({active: true})	

	updateVisualizationType: (type) ->
		@visualization = type
		@updateAnnotations(true)

	updateAnnotations: (animate) ->
		@$el.find('.annotation').remove()

		console.log @visualization

		if @visualization == 'none' then return

		_.each(@model.get('sentences'), (sentence) =>
			sel = '#sentence-' + sentence.sentence
			$el = $(sel)
			$el.addClass('annotated')
			height = $el.height()
			
			if @visualization == 'opacity'
				opacity = sentence.count / 20
				minWidth = 10
				width = 10
			else
				minWidth = 1
				width = sentence.count * 1

			count = @model.getAnnotationCountFor( sentence.sentence)
			annotation = $('<span data-sentence="' + sentence.sentence + '" style="display: none; width: ' + minWidth + 'px; height: ' + height + 'px;" class="annotation"></span>')
#			annotation.append('<div class="annotation-counter">This section was marked as interesting ' + count + ' times.</div>')

			$el.before(annotation)
			if animate == true
				if @visualization == 'opacity'
					annotation.fadeTo('slow', opacity)
				else
					annotation.css({display: 'block'})
					annotation.animate({width: width})
			else
				if @visualization == 'opacity'
					annotation.fadeTo(0, opacity)
				else
					annotation.css({display: 'block'})
					annotation.width(width)


		)

	render: () =>
		text = _.first @texts.where({active: true})
		$('html, body').animate({scrollTop: 0}, 500)

		@$el.fadeOut({
			complete: =>
				$(@el).html(@template(text: @model, parts: @options.parts.toJSON() ))
				@$el.fadeIn({
					complete: =>
						@updateAnnotations(true)
				})
		})

		return @
