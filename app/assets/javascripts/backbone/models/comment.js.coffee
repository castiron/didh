class Didh.Models.Comment extends Backbone.Model

  paramRoot: 'comment'

  urlRoot: ->
    '/texts/' + @get('text_id') + '/comments'

class Didh.Collections.CommentsCollection extends Backbone.Collection
  model: Didh.Models.Comment

  initialize: () ->
    if @options && @options.textId then @textId = @options.textId

  url: () ->
    '/texts/' + @textId + '/comments';

  comparator: (comment) ->
    -comment.get('timestamp')