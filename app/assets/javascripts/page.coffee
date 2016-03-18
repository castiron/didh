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