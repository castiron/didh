class Didh.Routers.AppRouter extends Backbone.Router
	initialize: (options) ->
		@parts = new Didh.Collections.PartsCollection()
		@parts.reset options.parts
		@texts = new Didh.Collections.TextsCollection()
		@texts.reset options.texts

		@tocView = new Didh.Views.Frontend.TocView(el: $("#backbone-tocView"), parts: @parts, texts: @texts )
		@tocView.render()


	routes:
		"part/:id"	: "showPart"
		"text/:id"	: "showText"

	showText: (id) ->
		@tocView.closePane()

	showPart: (id) ->
		@tocView.showPart(@parts.get(id))

	init: ->
