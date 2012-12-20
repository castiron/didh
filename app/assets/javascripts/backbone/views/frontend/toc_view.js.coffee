Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TocView extends Backbone.View
	template: JST["backbone/templates/frontend/toc"]
	
	events: 
		"click .pane-toggle" : "togglePane"

	initialize: () ->
		@isOpen = false
		@parts = @options.parts
		@texts = @options.texts
		@router = @options.router
		@paneHeight = @.$el.height()
		@parts.bind('change:active', @highlightActivePart, @)
		@texts.bind('change:active', @closePane, @)

	normalizePaneHeight: () ->
		@.$el.find('.part').each( (i, part) =>
			$(part).height(@.paneHeight)
		)

	normalizePaneHeaderPosition: () ->
		$('.pane--title').each( ->
			paneHeight = $(@).parents('.pane--header').height()
			$(@).width(paneHeight)
		)		

	closePane: () ->
		if @isOpen == true then @.$el.animate(right: 0 )
		@isOpen = false

	openPane: () ->
		if @isOpen == false then @.$el.animate(right: (@.$el.width() * 2) + 8 )
		@isOpen = true

	togglePane: () ->
		togglePane: () ->
		if @isOpen == true
			@closePane()
		else
			@openPane()		

	highlightActivePart: () ->
		activePart = _.first(@parts.where({active: true}))
		@$el.find('.nav-item-part').each( ->
			$(@).css({'font-weight': 'normal'})
		)
		activeEl = @$el.find('.nav-item-part-' + activePart.get('id')).first()
		activeEl.css({'font-weight': 'bold'})

	showPart: (part) ->
		@parts.setActivePart(part.id)
		@openPane()
		@partsContainer = @.$el.find('.parts:first')
		target = @.$el.find('#toc-part-' + part.get('id'))
		@partsContainer.animate({top: -1 * target.position().top})

	render: =>
		$(@el).html(@template(parts: @parts, texts: @texts, activeText: @router.getRequestedText()))
		# @normalizePaneHeaderPosition() # TODO: Move this into a sidebar view, perhaps
		@normalizePaneHeight()

