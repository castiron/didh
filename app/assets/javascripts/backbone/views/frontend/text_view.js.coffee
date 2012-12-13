Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
	template: JST["backbone/templates/frontend/text"]

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@annotations = @options.annotations
		@router = @options.router
		@annotator = @options.annotator
		@model.bind('change', @render, @)
		@model.get('annotations').bind('change', @updateAnnotations, @)
#		@model.fetch()

	events: 
		"click .sentence" : "showAnnotator"

	showAnnotator: (event) ->
		@annotator.showAnnotatorOn(event.target, event)

	showText: (text) ->
		text = @texts.where({active: true})	

	updateAnnotations: () ->
		console.log 'change in text model annotations property detected'
		@model.get('annotations').each( (annotation) =>
			sel = '#sentence-' + annotation.get('sentence')
			$el = $(sel)
			$el.find('.annotation').remove()
			$el.prepend('<span class="annotation" style="color: red;">[' + annotation.get('count') + ']</span>')
		)

	render: () =>
		text = _.first @texts.where({active: true})
		$('html, body').animate({scrollTop: 0}, 500)

		@$el.fadeOut({
			complete: =>
				$(@el).html(@template(text: @model, parts: @options.parts.toJSON() ))
				@$el.fadeIn()
				@updateAnnotations()
		})

		return @
