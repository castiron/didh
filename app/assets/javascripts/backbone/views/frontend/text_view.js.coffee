Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
	template: JST["backbone/templates/frontend/text"]

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@annotations = @options.annotations
		@router = @options.router
		@annotator = @options.annotator
		@model.bind('change:isLoaded', @render, @)
		@model.bind('change:sentences', @updateAnnotations, @)

	events: 
		"click .sentence" : "showAnnotator"

	showAnnotator: (event) ->
		@annotator.showAnnotatorOn(event.target, event)

	showText: (text) ->
		text = @texts.where({active: true})	

	updateAnnotations: (animate) ->
		@$el.find('.annotation').remove()
		_.each(@model.get('sentences'), (sentence) =>
			sel = '#sentence-' + sentence.sentence
			$el = $(sel)
			$el.addClass('annotated')
			height = $el.height()
			width = sentence.count * 1
			annotation = $('<span style="width: 1px; height: ' + height + 'px;" class="annotation"></span>')
			$el.prepend(annotation)
			if animate == true
				annotation.animate({width: width})
			else
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
