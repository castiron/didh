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
  
  openToc = () ->
    $tocTab.addClass('open')
    $tocTabTrigger.addClass('open')
    $body.addClass('toc-open')
    $body.on('click', tocClickListener)

  closeToc = () ->
    $tocTab.removeClass('open')
    $tocTabTrigger.removeClass('open')
    $body.removeClass('toc-open')
    $body.off('click', tocClickListener)

  tocClickListener = (event) ->
    $target = $(event.target)

    if $($target.children()[0]).hasClass('toc-editions') || $target.hasClass('.toc-container, .toc-tab-trigger') || $target.parents('.toc-container, .toc-tab-trigger').length > 0
      return;
    else
      closeToc()

  $('[data-tab-toggle-trigger]').click((e) ->
    if $tocTab.hasClass('open')
      closeToc()
    else
      openToc()
  )

# for the edition tabs within the TOC
  $('[data-edition-toggle]').click((e) ->
    $('[data-edition-toggle]').removeClass('active')
    $(@).addClass('active')
    editionSelector = '#toc-edition-'+$(@).data('editionToggle')
    $(editionSelector).trigger('editionSelect', [$(@).data('editionToggle')])
  )
