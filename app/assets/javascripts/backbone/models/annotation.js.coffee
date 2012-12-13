class Didh.Models.Annotation extends Backbone.Model
	paramRoot: 'annotation'

	url: ->
		'/texts/' + @get('text') + '/annotations'

	incrementCount: ->
		count = parseInt(@.get('count')) + 1
		@.set({count: count})


class Didh.Collections.AnnotationsCollection extends Backbone.Collection
	model: Didh.Models.Annotation

	initialize: (models, options) ->
		@text = options.text
		@reset(models)

	url: ->
		'/texts/' + @text.get(id) + '/annotations';