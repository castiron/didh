Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.HudView extends Backbone.View
	template: JST["backbone/templates/frontend/hud"]

	events:
		"click .js-legend--toggle" 	: "hideInstructions"


	initialize: () ->
		@router = @options.router
		@texts = @options.texts
		@texts.bind('change:active', @render, @)
		@render()

	hideInstructions: () ->
		@$el.find('.legend').slideUp()
		$('body').switchClass('banner-open','banner-closed')
		false

	render: ->
		text = @texts.getActiveText()
		if text?
			$(@el).html(@template({text: text}))
			return @
