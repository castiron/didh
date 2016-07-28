#= require ./pane_view

Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.FeedbackView extends Didh.Views.Frontend.PaneView
	template: JST["backbone/templates/frontend/feedback"]

	events:
		# "click .js-content-nav--open-toggle"		: "toggleOpen"
		"click .js-content-feedback--visible-toggle"		: "toggleVisibility"
		"click #feedback-view-interesting" 			: "updateVisualizationType"
		"click #feedback-view-interesting-stacked" 	: "updateVisualizationType"
		"click #feedback-view-interesting-opacity" 	: "updateVisualizationType"

	initialize: () ->
		@firstCheck = true
		@currentPosition = 1
		@isStatic = @options.isStatic
		@parts = @options.parts
		@texts = @options.texts
		@defaultVisualization = 'opacity'
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
			return 'opacity'

		if @$el.find('#feedback-view-interesting').attr('checked') == 'checked'
			@$el.find('#feedback-view-interesting-label').removeClass('off')
			@$el.find('#feedback-view-interesting').removeClass('off')
			@$el.find("#feedback-view-interesting-stacked").removeClass('off')
			@$el.find("#feedback-view-interesting-opacity").removeClass('off')
			type = 'stacked'
			if @$el.find("#feedback-view-interesting-stacked").attr('checked') == 'checked'
				type = 'stacked'
			if @$el.find("#feedback-view-interesting-opacity").attr('checked') == 'checked'
				type = 'opacity'
		else
			type = 'none'
			@$el.find('#feedback-view-interesting-label').addClass('off')
			@$el.find('#feedback-view-interesting').addClass('off')
			@$el.find("#feedback-view-interesting-stacked").addClass('off')
			@$el.find("#feedback-view-interesting-opacity").addClass('off')
		type

	updateVisualizationType: () ->
		visualization = @getVisualizationType()
		@visualization = visualization
		@updateToogleAppearance(@visualization)
		Backbone.Mediator.publish('visualization:update', @visualization);

	updateToogleAppearance: (visualization) ->
		$stackedParent = @$el.find("#feedback-view-interesting-stacked").parents('li').first()
		$opacityParent = @$el.find("#feedback-view-interesting-opacity").parents('li').first()

		if $stackedParent.hasClass('active') then $stackedParent.removeClass('active')
		if $opacityParent.hasClass('active') then $opacityParent.removeClass('active')

		switch visualization
			when 'stacked'
				$stackedParent.addClass('active')
			when 'opacity'
				$opacityParent.addClass('active')

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

		$(@el).html(@template(text: @model, isStatic: @isStatic, visualization: visualization))

		@setOpenCloseHiddenPositions()
		@normalizePaneHeight()
		@updateToogleAppearance(visualization)
		if $('body').width() <= 1024 then @goToPosition(2)



