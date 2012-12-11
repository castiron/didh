Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TocView extends Backbone.View
	template: JST["backbone/templates/frontend/toc"]
	
	events: 
		"click .pane-close" : "closePane"

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@paneHeight = @.$el.height()
		@parts.bind('change:active', @render)

	normalizePaneHeight: () ->
		@.$el.find('.part').each( (i, part) =>
			$(part).height(@.paneHeight)
		)

	closePane: () ->
		@.$el.animate(right: 0 )


	normalizePaneHeaderPosition: () ->
		$('.pane--title').each( ->
			paneHeight = $(@).parents('.pane--header').height()
			$(@).width(paneHeight)
		)

	showPart: (part) ->
		@.$el.animate(right: (@.$el.width() * 2) - 4)
		@partsContainer = @.$el.find('.parts:first')
		target = @.$el.find('#toc-part-' + part.get('id'))
		@partsContainer.animate({top: -1 * target.position().top})

	render: =>
		console.log 'rendering toc'
		$(@el).append(@template(parts: @parts, texts: @texts))
		@normalizePaneHeaderPosition() # TODO: Move this into a sidebar view, perhaps
		@normalizePaneHeight()

