#= require ./pane_view

Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.FeedbackView extends Didh.Views.Frontend.PaneView
	template: JST["backbone/templates/frontend/feedback"]
	
	events: 
		"click .js-content-nav--open-toggle"		: "toggleOpen"
		"click .js-content-nav--visible-toggle"		: "toggleVisibility"
		"click #feedback-view-interesting" 			: "updateVisualizationType"
		"click #feedback-view-interesting-stacked" 	: "updateVisualizationType"
		"click #feedback-view-interesting-opacity" 	: "updateVisualizationType"

	initialize: () ->
		@firstCheck = true
		@currentPosition = 1
		@static = @options.static
		@parts = @options.parts
		@texts = @options.texts
		@defaultVisualization = 'stacked'
		@setupSubscriptions()

	setModel: (model) ->
		if @model?
			@model.off('change')
			@model.off('change:sentences')

		@model = model
		@model.bind('change', @render, @)
		@model.bind('change:sentences', @render, @)
		@model.bind('change:keywords_grouped', @render, @)

	getVisualizationType: () ->
		if @firstCheck == true 
			@firstCheck = false
			return 'stacked'

		if @$el.find('#feedback-view-interesting').attr('checked') == 'checked'
			type = 'stacked'
			if @$el.find("#feedback-view-interesting-stacked").attr('checked') == 'checked'
				type = 'stacked'
			if @$el.find("#feedback-view-interesting-opacity").attr('checked') == 'checked'
				type = 'opacity'
		else
			type = 'none'
		type

	updateVisualizationType: () ->
		visualization = @getVisualizationType()
		@visualization = visualization
		Backbone.Mediator.publish('visualization:update', @visualization);

	normalizePaneHeight: () ->
		@.$el.find('.part').each( (i, part) =>
			$(part).height(@.paneHeight)
		)

	setOpenCloseHiddenPositions: () ->
		firstPaneWidth = @$el.find('.level-0').first().width()
		secondPaneWidth = 376
		handleWidth = @$el.find('header').first().width()
		@positions = {
			0: -1 * (secondPaneWidth - handleWidth)
			1: 0
			2: (firstPaneWidth - handleWidth)
		}

	render: =>
		if @visualization?
			visualization = @visualization
		else
			visualization = @defaultVisualization

		$(@el).html(@template(text: @model, static: @static, visualization: visualization))

		@setOpenCloseHiddenPositions()
		@normalizePaneHeight()
		if $('body').width() <= 1024 then @goToPosition(2)



