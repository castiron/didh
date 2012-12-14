class Didh.Models.Annotation extends Backbone.Model
	paramRoot: 'annotation'

	url: ->
		'/texts/' + @get('text_id') + '/annotations'

class Didh.Collections.AnnotationsCollection extends Backbone.Collection
	model: Didh.Models.Annotation

	url: (model) ->
		console.log model
		'/texts/' + @text.get(id) + '/annotations';