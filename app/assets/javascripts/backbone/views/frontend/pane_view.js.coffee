Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.PaneView extends Backbone.View

  setupSubscriptions: () ->
    # When we're moving from pos 2 to pos 1 or from pos 1 to pos 2, the panes move in unison
    Backbone.Mediator.subscribe('pane:change', (position) =>
      if position == 2
        @goToPosition(position)
      else if position == 1 && @currentPosition == 2
        @goToPosition(position)
    , @);

    Backbone.Mediator.subscribe('panes:close', () =>
      @closeIfOpen()
    )

    # Panes need to recalculate height when the orientation changes
    Backbone.Mediator.subscribe('app:orientationchange', () =>
      @normalizePaneHeight()
    , @);

    # In some cases, the panes need to close when the annotator opens
    Backbone.Mediator.subscribe('annotator:open', () =>
      breakPosition = 0
      if $('body').width() <= 1280 then breakPosition = 1
      if @currentPosition <= breakPosition then @goToPosition(breakPosition + 1)
    , @);

  toggleOpen: (e) ->
    if e then e.stopPropagation()
    else
      switch @currentPosition
        when 2 then @goToPosition 1
        when 1 then @goToPosition 0
        when 0 then @goToPosition 1
      false

  toggleVisibility: (e) ->
    if e then e.stopPropagation()
    switch @currentPosition
      when 0 then @goToPosition 2
      when 1 then @goToPosition 2
      when 2 then @goToPosition 1
    false

  closeIfOpen: () ->
    if @currentPosition == 0 then @goToPosition(1)

  goToPosition: (position, recursionBuster) ->
    if @static? && @static == true && position == 0
      return false
    if @currentPosition != position
      switch position
        when 0
          $('body').addClass('nav-open')
          $('#backbone-feedbackView.nav-pane.pane-top').animate({left: 0})
        when 1
          $('body').addClass('nav-open')
          $('#backbone-feedbackView.nav-pane.pane-top').animate({left: 0})
        when 2
          $('body').removeClass('nav-open')
          $('#backbone-feedbackView.nav-pane.pane-top').animate({left: 266})

      @currentPosition = position
      Backbone.Mediator.publish('pane:change', position);