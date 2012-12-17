class Didh.Models.Keyword extends Backbone.Model
	paramRoot: 'keyword'

	url: -> 
		'keywords/'

class Didh.Collections.KeywordsCollection extends Backbone.Collection
	model: Didh.Models.Keyword

	url: -> 
		'keywords/'
