#= require ./pane_view

class Didh.Views.Frontend.TocView extends Didh.Views.Frontend.PaneView
	template: JST["backbone/templates/frontend/toc"]
	linkedPane: null

	events:
		"click .js-content-nav--open-toggle"		: "toggleOpen"
		"click .js-content-nav--visible-toggle"		: "toggleVisibility"

	initialize: () ->
		@currentPosition = 1
		@parts = @options.parts
		@texts = @options.texts
		@annotator = @options.annotator
		@router = @options.router
		@paneHeight = @.$el.height()
		@parts.bind('change:active', @highlightActivePart, @)
		@texts.bind('change:active', @closePane, @)

	normalizePaneHeight: () ->
		@.$el.find('.part').each( (i, part) =>
			$(part).height(@.paneHeight)
		)

	highlightActivePart: () ->
		activePart = _.first(@parts.where({active: true}))
		@$el.find('.nav-item-part').each( ->
			$(@).css({'font-weight': 'normal'})
		)
		activeEl = @$el.find('.nav-item-part-' + activePart.get('id')).first()
		activeEl.css({'font-weight': 'bold'})

	showPart: (part) ->
		@parts.setActivePart(part.id)
		@goToPosition(0)
		@partsContainer = @.$el.find('.parts:first')
		target = @.$el.find('#toc-part-' + part.get('id'))
		@partsContainer.animate({top: -1 * target.position().top})

	setOpenCloseHiddenPositions: () ->
		firstPaneWidth = @$el.find('.level-0').first().width()
		secondPaneWidth = @$el.find('.level-1').first().width()
		handleWidth = @$el.find('header').first().width()
		@positions = {
			0: -1 * (secondPaneWidth + 12 - 50)
			1: 0
			2: (firstPaneWidth - handleWidth)
		}

	render: =>
		$(@el).html(@template(parts: @parts, texts: @texts, activeText: @router.getRequestedText()))

		@setOpenCloseHiddenPositions()
		@normalizePaneHeight()

