#= require ./pane_view

class Didh.Views.Frontend.TocView extends Didh.Views.Frontend.PaneView
  template: JST["backbone/templates/frontend/toc"]
  linkedPane: null

  events:
    "click .js-content-toc--open-toggle"    : "toggleTocContents"
    "editionSelect .nav-pane.edition"       : "toggleEdition"

  initialize: () ->
    Backbone.Mediator.subscribe('pane:change', () =>
      @closeToc()
    )

    Backbone.Mediator.subscribe('toc:closeToc', () =>
      @closeToc()
    )
    @tocInitOpen = @options.toc
    @currentPosition = 1
    @editions = @options.editions
    @editions.setActiveEdition(2)
    @parts = @options.parts
    @texts = @options.texts
    @router = @options.router
    @parts.bind('change:active', @highlightActivePart, @)
    @texts.bind('change:active', @closeToc, @)
    @setupSubscriptions()
      
    unless @.$el.hasClass('open')
      setTimeout((() =>
        @.$el.find('.part-wrapper').each( ->
          $(@).removeClass('active')
        )), 500)

  highlightActivePart: () ->
    activePart = _.first(@parts.where({active: true}))
    activeText = _.first(@texts.where({active: true}))
    @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .nav-item-part').each( ->
      $(@).removeClass('active')
    )
    @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .part').each( ->
      $(@).removeClass('active')
    )

    if activePart
      $activePartEl = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .nav-item-part-' + activePart.get('id')).first()
      $activePartEl.addClass('active')
    if activeText
      $activeTextPartEl = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .toc-part-' + activePart.get('id')).first()
      $activeTextPartEl.parent('.part-wrapper').addClass('active')
      $activeTextEl = $activeTextPartEl.find('.nav-item-part-' + activeText.get('id')).first()
      $activeTextEl.addClass('active')

  toggleEdition: (e, editionId) ->
    @editions.setActiveEdition(editionId)
    $editionTab = $('#toc-edition-'+editionId)
    $('#backbone-tocView').animate({left: 0})
    $('#backbone-tocView').removeClass('open')
    $('#backbone-tocView').find('.part-wrapper').each( ->
      $(@).removeClass('active')
    )
    unless $editionTab.hasClass('active')
      $editionTab.siblings().removeClass('active')
      $editionTab.addClass('active')

  openToc: () ->
    @highlightActivePart(@)
    @$el.parent('[data-tab-toggle]').addClass('open')
    $('[data-tab-toggle-trigger]').parent('.toc-tab-trigger').addClass('open')
    $('body').css('overflow', 'hidden')

  closeToc: () ->
    @highlightActivePart(@)
    @$el.parent('[data-tab-toggle]').removeClass('open')
    $('[data-tab-toggle-trigger]').parent('.toc-tab-trigger').removeClass('open')
    $('body').css('overflow', 'auto')

  toggleTocContents: () ->
    paneWidth = @$el.find('.level-0').first().width()
    @$el.find('.part-wrapper').each( ->
      $(@).removeClass('active')
    )
    if @$el.hasClass('open')
      @$el.animate({left: 0})
      @$el.removeClass('open')
    else
      @$el.addClass('open')
      @$el.animate({left: -1 * paneWidth})
      @highlightActivePart(@)

  initEditionTab: (editionId) ->
    $('[data-edition-toggle='+editionId+']').addClass('active')
    $editionTab = $('#toc-edition-'+@editions.getActiveEditionId())
    $('.nav-pane.edition').removeClass('active')
    $editionTab.addClass('active')

  showPart: (part) ->
    @parts.setActivePart(part.id)
    @partsContainer = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .parts:first')
    target = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .toc-part-' + part.get('id'))
    twoLineBump = 0;
    targetHeight = target.prev().height()
    if targetHeight > 30 then twoLineBump = targetHeight - 22

    @partsContainer.animate({top: (-1 * target.position().top) + twoLineBump})

  setOpenCloseHiddenPositions: () ->
    firstPaneWidth = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .level-0').first().width()
    secondPaneWidth = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' .level-1').first().width()
    handleWidth = @$el.find('#toc-edition-'+@editions.getActiveEditionId()+' header').first().width()
    @positions = {
      0: 0
      1: 0
      2: 0
    }

  render: =>
    $(@el).html(@template(editions: @editions, parts: @parts, texts: @texts, activeText: @router.getRequestedText()))
    @setOpenCloseHiddenPositions()

    if @tocInitOpen
      setTimeout((() ->
       $('[data-tab-toggle]').addClass('open')
       $('[data-tab-toggle-trigger]').parent('.toc-tab-trigger').addClass('open')
       $('body').css('overflow', 'hidden')
      ), 500)

