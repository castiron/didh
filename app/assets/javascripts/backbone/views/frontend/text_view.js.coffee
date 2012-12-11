Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
	template: JST["backbone/templates/frontend/text"]

	initialize: () ->
		@parts = @options.parts
		@texts = @options.texts
		@model = @texts.get(1)
		@model.bind('change', @render);
		@model.fetch()

	showText: (text) ->
		$('html, body').animate({scrollTop: 0}, 500)
		@$el.fadeOut({
			complete: =>
				text.fetch({
					success: =>
						@model = text
						@parts.get(text.get('part')).set({active: true})
						console.log @parts
						@render()
						@$el.fadeIn()
				})
		})

	render: =>
		$(@el).html(@template(text: @model, parts: @options.parts.toJSON() ))
		return @
