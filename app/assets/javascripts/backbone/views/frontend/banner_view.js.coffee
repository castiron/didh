Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.BannerView extends Backbone.View
	instructionsTemplate: JST["backbone/templates/frontend/banner_instructions"]
	keywordAddedTemplate: JST["backbone/templates/frontend/banner_keyword_added"]


	events:
		"click .js-legend--toggle" 	: "hideInstructions"

	initialize: () ->
		if @$el.is(':visible') then @isVisible = false else @isVisible = true
		@setupSubscriptions()
		@render(@instructionsTemplate)
		if @$el.attr('data-hide-instructions') != '1'
			@showBanner()

	hideInstructions: () ->
		# Send an XHR request to Rails, which will in turn set session data to prevent
		# the instructions from appearing again.
		$.ajax('/debates/hide_instructions.json')
		@hideBanner()

	hideBanner: (callback) ->
		if @isVisible == true
			@$el.find('.legend').slideUp( 250, callback )
			$('body').switchClass('banner-open','banner-closed')
			@isVisible = false
		false

	reloadBanner: (hideCallback, showCallback) ->
		if @isVisible == true
			@hideBanner( =>
				hideCallback()
				@showBanner()
			)
		else
			hideCallback()
			@showBanner()

	showBanner: (callback) ->
		if @isVisible == false
			@$el.find('.legend').slideDown( 500, callback)
			$('body').switchClass('banner-close','banner-open')
			@isVisible = true
		false

	showKeywordAddedBanner: (keyword) ->
		if @isVisible == false
			@reloadBanner( =>
				@render(@keywordAddedTemplate)
			)
			setTimeout( =>
				@hideBanner()
			, 5000)

	setupSubscriptions: () ->
		Backbone.Mediator.subscribe('annotator:keyword_added', (keyword) =>
			@showKeywordAddedBanner(keyword)
		, @);

	render: (template) ->
		@$el.hide()


		$(@el).html(template({}))
		@$el.show()

