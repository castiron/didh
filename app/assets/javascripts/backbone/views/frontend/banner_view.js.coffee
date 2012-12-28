Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.BannerView extends Backbone.View
	template: JST["backbone/templates/frontend/banner"]

	events:
		"click .js-legend--toggle" 	: "hideInstructions"

	hideInstructions: () ->
		# Send an XHR request to Rails, which will in turn set session data to prevent
		# the instructions from appearing again.
		$.ajax('/debates/hide_instructions.json')
		@$el.find('.legend').slideUp()
		$('body').switchClass('banner-open','banner-closed')
		false

	initialize: () ->
		if @$el.attr('data-hide-instructions') == '1'
			@remove()
		else
			@render()

	render: ->
