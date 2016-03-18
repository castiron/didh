#= require ./pane_view

class Didh.Views.Frontend.TocView extends Didh.Views.Frontend.PaneView
  template: JST["backbone/templates/frontend/toc"]
  linkedPane: null

  events:
    "click .js-content-toc--open-toggle"    : "toggleTocContents"
    # "click .js-content-nav--visible-toggle"   : "toggleVisibility"
    # "click [data-tab-toggle]"   : "toggleVisibility"

  initialize: () ->
    @currentPosition = 1
    @parts = @options.parts
    @texts = @options.texts
    @router = @options.router
    @paneHeight = @.$el.height()
    @parts.bind('change:active', @highlightActivePart, @)
    @texts.bind('change:active', @closeToc, @)
    @addToggleHandler(@$el, @texts)
    @setupSubscriptions()

  normalizePaneHeight: () ->
    @.$el.find('.part').each( (i, part) =>
      $(part).height(@.paneHeight)
    )

  highlightActivePart: () ->
    activePart = _.first(@parts.where({active: true}))
    activeText = _.first(@texts.where({active: true}))
    @$el.find('.nav-item-part').each( ->
      $(@).removeClass('active')
    )
    @$el.find('.part').each( ->
      $(@).removeClass('active')
    )
    if activePart
      $activePartEl = @$el.find('.nav-item-part-' + activePart.get('id')).first()
      $activePartEl.addClass('active')
    if activeText
      $activeTextPartEl = @$el.find('#toc-part-' + activePart.get('id')).first()
      $activeTextPartEl.parent('.part-wrapper').addClass('active')
      $activeTextEl = $activeTextPartEl.find('.nav-item-part-' + activeText.get('id')).first()
      $activeTextEl.addClass('active')
  
  addToggleHandler: (el, texts) ->
    if _.first(texts.where({active: true}))
      el.find('.part-wrapper').each( ->
        $(@).removeClass('active')
      )

    $body = $('body')
    $tab = @$el.parent('[data-tab-toggle]');
    $('[data-tab-toggle-trigger]').click((e) ->
      if $tab.hasClass('open')
        $tab.removeClass('open')
        $body.css('overflow', 'auto')
      else
        $tab.addClass('open')
        $body.css('overflow', 'hidden')
    )

  closeToc: () ->
    @highlightActivePart(@)
    @$el.parent('[data-tab-toggle]').removeClass('open')
    $('body').css('overflow', 'auto')

  toggleTocContents: () ->
    paneWidth = @$el.find('.level-0').first().width()
    console.log('pane', paneWidth)
    if @$el.position().left == -495
      @$el.animate({left: 0})
      @$el.find('.part-wrapper').each( ->
        $(@).removeClass('active')
      )
    else
      @$el.animate({left: -495})

  showPart: (part) ->
    @parts.setActivePart(part.id)
    @partsContainer = @.$el.find('.parts:first')
    target = @.$el.find('#toc-part-' + part.get('id'))
    @partsContainer.animate({top: -1 * target.position().top})

  setOpenCloseHiddenPositions: () ->
    firstPaneWidth = @$el.find('.level-0').first().width()
    secondPaneWidth = @$el.find('.level-1').first().width()
    handleWidth = @$el.find('header').first().width()
    @positions = {
      0: 0
      1: 0
      2: 0
    }

  render: =>
    $(@el).html(@template(parts: @parts, texts: @texts, activeText: @router.getRequestedText()))
    @setOpenCloseHiddenPositions()
    # @toggleTocContents();
    # @normalizePaneHeight()

