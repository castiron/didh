Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.FeedbackView extends Backbone.View
	template: JST["backbone/templates/frontend/feedback"]
	
	events: 
		"click .pane-toggle"						: "togglePane"
		"click .pane-close" 						: "closePane"
		"click .pane-open" 							: "openPane"
		"click #feedback-view-interesting" 			: "updateVisualizationType"
		"click #feedback-view-interesting-stacked" 	: "updateVisualizationType"
		"click #feedback-view-interesting-opacity" 	: "updateVisualizationType"

	initialize: () ->
		@isOpen = false
		@parts = @options.parts
		@texts = @options.texts
		@router = @options.router
		@defaultVisualization = 'stacked'
	
	setModel: (model) ->
		if @model?
			@model.off('change')
			@model.off('change:sentences')

		@model = model
		@model.bind('change', @render, @)
#		@model.bind('change:sentences', @render, @)
#		@render()

	getVisualizationType: () ->
		if @$el.find('#feedback-view-interesting').attr('checked') == 'checked'
			type = 'stacked'
			if @$el.find("#feedback-view-interesting-stacked").attr('checked') == 'checked'
				type = 'stacked'
			if @$el.find("#feedback-view-interesting-opacity").attr('checked') == 'checked'
				type = 'opacity'
		else
			type = 'none'
		console.log type
		type

	updateVisualizationType: () ->
		visualization = @getVisualizationType()
		@visualization = visualization
		@router.updateVisualizationType(@visualization)

	closePane: (e) ->
		if e? then e.stopPropagation()
		@$el.find('.show-if-pane-open').hide()
		@$el.find('.show-if-pane-closed').show()
		if @isOpen == true then @.$el.animate(right: 0 )
		@isOpen = false
		false

	openPane: (e) ->
		if e? then e.stopPropagation()
		@$el.find('.show-if-pane-open').show()
		@$el.find('.show-if-pane-closed').hide()
		if @isOpen == false then @.$el.animate(right: (@.$el.width()) + 4)
		@isOpen = true
		@el.
		false

	togglePane: (e) ->
		if e? then e.stopPropagation()
		togglePane: () ->
		if @isOpen == true
			@closePane(e)
		else
			@openPane(e)		
		false

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
		if @visualization?
			visualization = @visualization
		else
			visualization = @defaultVisualization
		$(@el).html(@template(text: @model, visualization: visualization))
		@normalizePaneHeight()


