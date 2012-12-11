class Didh.Routers.AppRouter extends Backbone.Router
	initialize: (options) ->
		@parts = new Didh.Collections.PartsCollection()
		@parts.reset options.parts
		@texts = new Didh.Collections.TextsCollection()
		@texts.reset options.texts

		@textView = new Didh.Views.Frontend.TextView(el: $("#backbone-textView"), parts: @parts, texts: @texts )
		@tocView = new Didh.Views.Frontend.TocView(el: $("#backbone-tocView"), parts: @parts, texts: @texts )
		@tocView.render()
		@textView.render()

	routes:
		"part/:id"	: "showPart"
		"text/:id"	: "showText"

	showText: (id) ->
		@tocView.closePane()
		@textView.showText(@texts.get(id))

	showPart: (id) ->
		@tocView.showPart(@parts.get(id))

	init: ->
