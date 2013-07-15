Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.SingleCommentView extends Backbone.View

  template: JST["backbone/templates/frontend/comment"]

  tagName: 'li'
  className: 'comment-drawer--comment'
  loadedViews: new Array

  events: {
    'click .js-action-reply': 'toggleReply'
    'click .js-action-remove': 'deleteComment'
  }

  deleteComment: (e) ->
    if e?
      e.preventDefault()
      e.stopPropagation()
    @model.destroy({wait: true})

  toggleReply: (e) ->
    if e?
      e.preventDefault()
      e.stopPropagation()
    if @$el.hasClass('active')
      @$el.removeClass('active')
    else
      @$el.addClass('active')

  initialize: (options) ->
    @authenticated = options.authenticated
    @id = @model.id
    @render()

  onRemove: () ->
    _.each(@loadedViews, (view) =>
      view.remove()
      view.unbind()
# TODO: fix recursive garbage collection
#      if view.onRemove then view.onRemove()
    )

  render: () ->

    if window.currentUser? && window.currentUser.admin == true
      admin = true
    else
      admin = false

    $(@el).html(@template({
      model: @model,
      authenticated: @authenticated,
      admin: admin
    }))

    comments = @collection.where({parent_id: @model.id})
    if comments.length > 0
      $container = @$el.find('.js-comment-container:first')
      _.each(comments, (comment) =>
        child = new Didh.Views.Frontend.SingleCommentView({model: comment, authenticated: @authenticated, collection: @collection})
        @loadedViews.push child
        $container.append(child.$el)
      )




class Didh.Views.Frontend.CommentsView extends Backbone.View

  template: JST["backbone/templates/frontend/comments"]

  events: {
    'click .js-open-authentication': 'openAuth'
    'click .js-comment-close':  'close'
    'submit form': 'saveComment'
  }

  openAuth: (e) ->
    if e?
      e.preventDefault()
    Backbone.Mediator.publish('authentication:show')

  saveComment: (e) ->

    if e? then e.preventDefault()

    $target = $(e.target)
    body = $target.find('textarea').val()

    if $target.find('[name="name"]').length > 0
      name = $target.find('[name="name"]').val()
    else
      name = ''

    if $target.find('[name="name"]').length > 0
      email = $target.find('[name="email"]').val()
    else
      email = ''

    errorsEl = $target.find('.errors')

    if $target.data().parent then parent = $target.data().parent else parent = null
    comment = new Didh.Models.Comment({
      body: body
      author_name: name
      author_email: email
      sentence_checksum: @currentSentenceId
      text_id: @currentTextId
      parent_id: parent
    })
    comment.save({}, {
      success: () =>
        @collection.add(comment)
        $target.find('textarea').val('')
      error: (comment, xhr, options) =>
        errorsEl.html('')
        errors = []
        response = JSON.parse(xhr.responseText)
        _.each(response, (fieldErrors, fieldName) =>
          fieldName = fieldName.replace('_',' ')
          _.each(fieldErrors, (fieldError) =>
            errorsEl.append("<li>#{fieldName} #{fieldError}</li>")
            errors.push("#{fieldName} #{fieldError}")
          )
        )
    })

  open: (textId, sentenceId) ->
    @currentSentenceId = sentenceId
    @currentTextId = textId
    @collection.textId = @currentTextId
    params = {data: {sentence: sentenceId}}
    @collection.fetch(params)
    @$el.removeClass('open')
    @$el.addClass('open')

  close: (e) ->
    if e? then e.preventDefault()
    @router.navigate('text/' + @currentTextId)
    @$el.removeClass('open')

  initialize: () ->
    @loadedViews = []
    @router = @options.router
    @collection = new Didh.Collections.CommentsCollection()

    @collection.bind('add', () =>
        @render()
    )

    @collection.bind('remove', () =>
        @render()
    )

    @collection.bind('reset', () =>
      @render()
    )

  render: (template) ->

    _.each(@loadedViews, (view) =>
        view.remove()
        view.unbind()
        if view.onRemove then view.onRemove()
    )
    @loadedViews = []

    comments = @collection.where({parent_id: false})

    selector = "#sentence-#{@currentSentenceId}"
    @currentSentenceText = $(selector).html()

    if window.currentUser? && window.currentUser.id?
      authenticated = true
    else
      authenticated = false

    if window.currentUser? && window.currentUser.screenName?
      screenName = window.currentUser.screenName
    else
      screenName = false

    $(@el).html(@template({
      reference: @currentSentenceText
      authenticated: authenticated
      screenName: screenName
    }))

    comments = @collection.where({parent_id: null})
    container = @$el.find('.js-comment-container:first')
    _.each(comments, (comment) =>
      child = new Didh.Views.Frontend.SingleCommentView({model: comment, authenticated: authenticated, collection: @collection})
      @loadedViews.push child
      container.append(child.$el)
    )

    @$el.find('textarea').autosize()


