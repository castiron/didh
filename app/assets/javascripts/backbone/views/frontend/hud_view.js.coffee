Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.HudView extends Backbone.View
  template: JST["backbone/templates/frontend/hud"]

  authVisible: false

  events:
    'click'   : "requestScroll"
    'click .js-open-authentication'   : "showAuthentication"
    'click .js-close-authentication'   : "hideAuthentication"

  initialize: () ->
    @router = @options.router
    @texts = @options.texts
    @texts.bind('change:active', @render, @)
    @render()

  hideAuthentication: (e) ->
    if e? then e.preventDefault()
    @authVisible = false
    @$el.find('.js-authentication').animate({bottom: 0}, 200)
    @router.navigate 'text/' + @texts.getActiveTextId()

  showAuthentication: (e, animate = true) ->
    if e? then e.preventDefault()
    @authVisible = true
    $el = @$el.find('.js-authentication')
    height = $el.outerHeight()
    if animate == true
      $el.animate({bottom: height * -1}, 200)
    else
      console.log 'b'
      $el.css({bottom: height * -1})

    @router.navigate 'text/' + @texts.getActiveTextId() + '/auth'

  requestScroll: () ->
    Backbone.Mediator.publish('text:request_scroll');

  render: ->
    text = @texts.getActiveText()
    if text?
      $(@el).html(@template({text: text, currentUser: window.currentUser}))
      if @authVisible then @showAuthentication(null, false)
      return @
