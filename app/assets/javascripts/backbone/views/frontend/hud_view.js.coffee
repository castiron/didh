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
    @$el.find('.js-authentication').fadeOut()
    @router.navigate 'text/' + @texts.getActiveTextId()

  showAuthentication: (e) ->
    if e? then e.preventDefault()
    @authVisible = true
    @$el.find('.js-authentication').fadeIn()
    @router.navigate 'text/' + @texts.getActiveTextId() + '/auth'

  requestScroll: () ->
    Backbone.Mediator.publish('text:request_scroll');

  render: ->
    text = @texts.getActiveText()
    if text?
      $(@el).html(@template({text: text, currentUser: window.currentUser}))
      if @authVisible then @showAuthentication()
      return @
