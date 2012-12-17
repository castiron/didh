Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.FeedbackView extends Backbone.View
	template: JST["backbone/templates/frontend/feedback"]
	
	events: 
		"click .pane-toggle"						 : "togglePane"
		"click .pane-close" 						:  "closePane"
		"click #feedback-view-interesting" 			:  "setVisualizationType"
		"click #feedback-view-interesting-stacked" 	:  "setVisualizationType"
		"click #feedback-view-interesting-opacity" 	:  "setVisualizationType"

	initialize: () ->
		@isOpen = false
		@parts = @options.parts
		@texts = @options.texts
		@router = @options.router
		@model.bind('change:isLoaded', @render, @)

	setVisualizationType: () ->
		if @$el.find('#feedback-view-interesting').attr('checked') == 'checked'
			type = 'stacked'
			if @$el.find("#feedback-view-interesting-stacked").attr('checked') == 'checked'
				type = 'stacked'
			if @$el.find("#feedback-view-interesting-opacity").attr('checked') == 'checked'
				type = 'opacity'
		else
			type = 'none'
		console.log type
		@router.setAnnotationType(type)

	closePane: (e) ->
		e.stopPropagation()
		if @isOpen == true then @.$el.animate(right: 0 )
		@isOpen = false

	openPane: (e) ->
		e.stopPropagation()
		if @isOpen == false then @.$el.animate(right: (@.$el.width()) + 4)
		@isOpen = true

	togglePane: (e) ->
		e.stopPropagation()
		togglePane: () ->
		if @isOpen == true
			@closePane(e)
		else
			@openPane(e)		

	normalizePaneHeight: () ->
		@.$el.find('.part').each( (i, part) =>
			$(part).height(@.paneHeight)
		)

	normalizePaneHeaderPosition: () ->
		@.$el.find('.pane--title').each( ->
			paneHeight = $(@).parents('.pane--header').height()
			$(@).width(paneHeight)
		)

	render: =>
		$(@el).append(@template(text: @model))
		@normalizePaneHeaderPosition() # TODO: Move this into a sidebar view, perhaps
		@normalizePaneHeight()


