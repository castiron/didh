Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.HudView extends Backbone.View
	template: JST["backbone/templates/frontend/hud"]

	events:
		"click" 	: "requestScroll"

	initialize: () ->
		@texts = @options.texts
		@texts.bind('change:active', @render, @)
		@render()

	requestScroll: () ->
		Backbone.Mediator.publish('text:request_scroll');

	render: ->
		text = @texts.getActiveText()
		if text?
			$(@el).html(@template({text: text}))
			return @
