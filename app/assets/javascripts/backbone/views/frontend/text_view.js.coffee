Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
	template: JST["backbone/templates/frontend/text"]

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@router = @options.router
		@annotator = @options.annotator
		@model = @texts.get(1)
		@texts.bind('change:active', @render, @)
		@model.fetch()

	events: 
		"click .sentence" : "showAnnotator"

	showAnnotator: (event) ->
		@annotator.showAnnotatorOn(event.target, event)

	showText: (text) ->
		text = @texts.where({active: true})	

	render: =>
		text = _.first @texts.where({active: true})

		$('html, body').animate({scrollTop: 0}, 500)
		@$el.fadeOut({
			complete: =>
				$(@el).html(@template(text: text, parts: @options.parts.toJSON() ))
				@$el.fadeIn()
		})

		return @
