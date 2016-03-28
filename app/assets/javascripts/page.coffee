try
  Typekit.load(
    active: ->
      windowHeight = $(window).height()
      contentHeight = $('.js-content').outerHeight()
      if contentHeight < windowHeight
        $('.js-content').outerHeight(windowHeight)
  )
catch e

# TODO temporary; remove once real controls are in place
$ ->
  $('.has-comment').click((event) ->
    $('.comment-drawer').addClass('open')
    event.preventDefault()      
  )
  $('.js-comment-toggle').click((event) ->
    $('.comment-drawer').removeClass('open')
    event.preventDefault()
  )
  $('.icon-reply').click((event) ->
    $(@).parent('.comment-drawer--comment').addClass('active')
    event.preventDefault()
  )
# for the TOC tab
  $body = $('body')
  $tocTab = $('[data-tab-toggle]');
  $tocTabTrigger = $('[data-tab-toggle-trigger]').parent('li');
  $('[data-tab-toggle-trigger]').click((e) ->
    if $tocTab.hasClass('open')
      $tocTab.removeClass('open')
      $tocTabTrigger.removeClass('open')
      $body.css('overflow', 'auto')
    else
      $tocTab.addClass('open')
      $tocTabTrigger.addClass('open')
      $body.css('overflow', 'hidden')
  )

# for the edition tabs within the TOC
  $('[data-edition-toggle]').click((e) ->
    $('[data-edition-toggle]').removeClass('active')
    $(@).addClass('active')
    editionSelector = '#toc-edition-'+$(@).data('editionToggle')
    $(editionSelector).trigger('editionSelect', [$(@).data('editionToggle')])
  )
