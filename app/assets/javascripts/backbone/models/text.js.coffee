class Didh.Models.Text extends Backbone.Model
	paramRoot: 'text'

	defaults:
		label: null

	getAuthorsList: ->
		names = (author.name for author in @.get('authors'))
		names.join(', ')


class Didh.Collections.TextsCollection extends Backbone.Collection
	model: Didh.Models.Text
	url: '/texts'

	ByPartGrouped: (partId, count) ->
		texts = @where({'part': partId})
		out = new Array
		out.push new Array
		textCounter = 0
		_.each texts, (text) ->
			if textCounter == count
				out.push new Array
				textCounter = 0
			out[out.length - 1].push(text)
			textCounter++
		out