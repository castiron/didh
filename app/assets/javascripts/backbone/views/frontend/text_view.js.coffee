Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.TextView extends Backbone.View
  template: JST["backbone/templates/frontend/text"]

  events:
    "click .sentence" 	: "requestAnnotator"

  initialize: () ->
    @parts = @options.parts
    @texts = @options.texts
    @annotations = @options.annotations
    @router = @options.router

    @setupSubscriptions()

    if @options.visualization?
      @visualization = @options.visualization
    else
      @visualization = 'none'


    @model.bind('change:isLoaded', @render, @)
    @model.bind('change:sentences', @updateAnnotations, @)

  setupSubscriptions: () ->
    Backbone.Mediator.subscribe('visualization:update', (type) =>
      @updateVisualizationType(type)
    , @)
    Backbone.Mediator.subscribe('text:request_scroll', () =>
      @scrollTop()
    , @)

  requestAnnotator: (e) ->
    if $(e.target).hasClass('sentence')
      Backbone.Mediator.publish('annotator:request', e.target, e);

  showAnnotationDetail: (e) ->
    $el = $(e.target)
    $el.find('.annotation-counter').show()

  showText: (text) ->
    text = @texts.where({active: true})

  updateVisualizationType: (type) ->
    @visualization = type
    @updateAnnotations(true)

  getCurrentVisualizationType: () ->
    @visualization

  updateAnnotations: (animate) ->
    @$el.find('.annotation').remove()

    if @visualization == 'none' then return

    # Used for debugging indexed sentences. Underlines sentences that have been indexed.
    #_.each(@model.get('keywords_grouped'), (sentence) =>
    #	sel = '#sentence-' + sentence.sentence
    #	$el = $(sel)
    #	$el.addClass('indexed')
    #)

    _.each(@model.get('sentences'), (sentence) =>
      sel = '#sentence-' + sentence.sentence
      $el = $(sel)
      $el.addClass('annotated')
      height = $el.height()

      if @visualization == 'opacity'
        opacity = sentence.count / 20
        minWidth = 10
        width = 10
      else
        minWidth = 1
        width = sentence.count * 1

      # unused
      # count = @model.getAnnotationCountFor( sentence.sentence)
      annotation = $('<span data-sentence="' + sentence.sentence + '" style="display: none; width: ' + minWidth + 'px; height: ' + height + 'px;" class="annotation"></span>')

      $el.before(annotation)
      if animate == true
        if @visualization == 'opacity'
          annotation.fadeTo('slow', opacity)
        else
          annotation.css({display: 'block'})
          annotation.animate({width: width})
      else
        if @visualization == 'opacity'
          annotation.fadeTo(0, opacity)
        else
          annotation.css({display: 'block'})
          annotation.css({width: width + 'px'})
    )

  scrollTop: () ->
    $('html, body').animate({scrollTop: 0}, 500)

  underlineCommentedSentences: () ->
    comments = @model.get('comments')
    _.each(comments, (count, checksum) =>
      selector = '#sentence-' + checksum
      $el = @$el.find(selector)
      $el.addClass('has-comment')
      count = @model.getCommentCountFor(checksum)
      paragraph = $el.closest('p')
      paragraph.addClass('contains-comment')
      pcount = paragraph.attr('data-count')
      if pcount? then pcount = parseInt(pcount) else pcount = 0
      pcount = pcount + parseInt(count)
      paragraph.attr('data-count', pcount)
    )
    @$el.find('[data-count]').each (index, el) ->
      $el = $(el)
      count = $el.attr('data-count')
      $el.prepend('<b class="comment-count">' + count + '<span> comments</span></b>')



  render: () ->
    text = _.first @texts.where({active: true})
    $('html, body').animate({scrollTop: 0}, 500)

    @$el.fadeOut({
      complete: =>
        $(@el).html(@template(text: @model, parts: @options.parts.toJSON() ))
        Backbone.Mediator.publish('text:rendered')
        @underlineCommentedSentences()
        @$el.fadeIn({
          complete: =>
            @updateAnnotations(true)
        })
    })

    return @
