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
	$('.js-comment-toggle').click((event) ->
		$('.comment-drawer').toggleClass('open')
		event.preventDefault()
	)
	$('.comment-drawer--reply').click((event) ->
		$(@).parent('.comment-drawer--comment').addClass('active')
		event.preventDefault()
	)
