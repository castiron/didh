Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.AnnotatorView extends Backbone.View
  template: JST["backbone/templates/frontend/annotator"]

  events:
    'click .annotate-close'			: 'stopAnnotating'
    'click .annotate-interesting'	: 'annotateInteresting'
    'click .annotate-comment'	: 'annotateComment'
    'click .annotate-index'			: 'annotateIndex'
    'submit #annotate-index-form'	: 'createIndexKeyword'

  initialize: () ->
    @annotatorHeight = 0
    @currentSentenceId = null
    @router = @options.router

    # Assign collection objects
    @parts = @options.parts
    @keywords = @options.keywords
    @annotations = @options.annotations
    @texts = @options.texts
    @setupSubscriptions()

  setupSubscriptions: () ->
    Backbone.Mediator.subscribe('annotator:request', (sentenceEl, event) =>
      @showAnnotatorOn(sentenceEl, event)
    , @)

    Backbone.Mediator.subscribe('pane:change', (position) =>
      breakPosition = 0
      if $('body').width() <= 1280 then breakPosition = 1
      if position <= breakPosition then @stopAnnotating()
    , @)

  calculateAnnotatorLocationFor: (sentenceEl, event) ->
    # We only set the height once, on the first appearance, and then treat it as constant.
    # We do this so that the changing height of the annotator doesn't mess up the position.
    if @annotatorHeight == 0 then @annotatorHeight = @$el.height()
    clickX = event.pageX
    clickY = event.pageY
    position = {top: (clickY - @annotatorHeight - 40)+ 'px', left: (clickX - 43) + 'px'}

  showAnnotatorOn: (sentenceEl, event) ->
    @stopAnnotating()

    Backbone.Mediator.publish('annotator:open');
    @currentSentenceEl = $(sentenceEl)
    @currentSentenceId = @currentSentenceEl.attr('data-id')
    @currentSentenceEl.addClass('hover')
    @$el.css(@calculateAnnotatorLocationFor(sentenceEl, event))

    # Render the sucker
    @render()

    # Then apply any effects
    @$el.fadeIn(75, =>
      @$el.find('.js-right').animate({ left: 316}, 250)

      # Bind a global click event to hide the annotator
      $('html').on('click', (event) =>
        if event.target != @el && $(event.target).parents().index(@$el) == -1
          @stopAnnotating()
      )
    )

  stopAnnotating: (e) ->
    if @$el.is(':visible')
      # Unbind a global click event to hide the annotator
      $('html').off('click')
      Backbone.Mediator.publish('annotator:closed');
      @$el.hide()
      if @currentSentenceEl? then @currentSentenceEl.removeClass('hover')
      @currentSentenceEl = null
      @currentSentenceId = null

  annotateComment: (e) ->
    if e? then e.preventDefault()
    activeText = @texts.getActiveText()
    currentSentenceId = @currentSentenceId
    @router.navigate("text/#{activeText.id}/comment/#{currentSentenceId}", true)
    @stopAnnotating()


  annotateInteresting: (e) ->
    activeText = @texts.getActiveText()
    annotation = new Didh.Models.Annotation({
      sentence: @currentSentenceId
      text_id: activeText.id
    })
    annotation.save({}, {
      success: =>
        activeText.incrementAnnotationCount(@currentSentenceId)
        @stopAnnotating()
      error: ->
        @stopAnnotating()
    })

  annotateIndex: (e) ->
    # TODO: Set focus on the input
    distance = @$el.find('.annotator-pane').first().height() * -1
    @$el.find('.annotator-panes').animate({top: distance})

  createIndexKeyword: (e) ->
    word = @$el.find('.annotate-index-input input').first().val()
    if !word
      @$el.find('.annotate-index-input').first().effect("shake", { times:2, distance: 5}, 50);
    else
      keyword = new Didh.Models.Keyword({
        sentence: @currentSentenceId
        word: word
        text_id: @texts.getActiveText().id
      })
      activeText = @texts.getActiveText()
      keyword.save({}, {
        success: =>
          console.log 'success'
          activeText.incrementGroupedKeywordCount(@currentSentenceId)
          Backbone.Mediator.publish('annotator:keyword_added', keyword);
          @stopAnnotating()
        error: =>
          console.log 'error'
          Backbone.Mediator.publish('annotator:keyword_add_failed', keyword);
          @stopAnnotating()
      })
    false

  render: =>
    context = {
      text: @texts.getActiveText()
      sentenceId: @currentSentenceId
    }
    if context.text? then context.annotationCount = context.text.getAnnotationCountFor(@currentSentenceId) else context.annotationCount = 0
    if context.text? then context.commentCount = context.text.getCommentCountFor(@currentSentenceId) else context.commentCount = 0
    console.log context.commentCount, @currentSentenceId
    $(@el).html(@template(context))
    return @
