class Didh.Models.Edition extends Backbone.Model
	paramRoot: 'edition'

	defaults:
		label: null

class Didh.Collections.EditionsCollection extends Backbone.Collection
	model: Didh.Models.Edition
	url: '/editions'

	getActiveEditionId: () ->
	  actiuveEdition = @getActiveEdition()
	  if actiuveEdition?
	    actiuveEdition.id
	  else
	    null

	getActiveEdition: () ->
	  activeEdition = _.first(@.where({active: true}))

	setActiveEdition: (editionId) ->
		_.each(@.where({active: true}), (edition) ->
			edition.set({active: false}, {silent: true})
		)
		@.get(editionId).set({active: true})
