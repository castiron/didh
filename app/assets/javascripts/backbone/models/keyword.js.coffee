class Didh.Models.Keyword extends Backbone.Model
	paramRoot: 'keyword'

	url: ->
		'/texts/' + @get('text_id') + '/keywords'

class Didh.Collections.KeywordsCollection extends Backbone.Collection
	model: Didh.Models.Keyword

	url: (model) ->
		'/texts/' + @text.get(id) + '/keywords';
