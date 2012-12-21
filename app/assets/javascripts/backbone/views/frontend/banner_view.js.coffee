Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.BannerView extends Backbone.View
	template: JST["backbone/templates/frontend/banner"]

	events:
		"click .js-legend--toggle" 	: "hideInstructions"

	hideInstructions: () ->
		@$el.find('.legend').slideUp()
		$('body').switchClass('banner-open','banner-closed')
		false

	initialize: () ->
		@texts = @options.texts
		@router = @options.router
		@texts.bind('change:active', @render, @)
		@render()

	render: ->
		text = @texts.getActiveText()
		if text?
			showHud = true
			$(@el).html(@template({showHud: true, text: text}))
			return @
