class Didh.Models.Sentence extends Backbone.Model
  paramRoot: 'sentence'

  url: ->
    '/texts/' + @get('text_id') + '/sentences'

class Didh.Collections.SentenceCollection extends Backbone.Collection
  model: Didh.Models.Keyword

  url: (model) ->
    '/texts/' + @text.get(id) + '/sentences';
