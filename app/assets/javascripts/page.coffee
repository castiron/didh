try
	Typekit.load(
		active: ->
			windowHeight = $(window).height()
			contentHeight = $('.js-content').outerHeight()
			if contentHeight < windowHeight
				$('.js-content').outerHeight(windowHeight)
	)
catch e
