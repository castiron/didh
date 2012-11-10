# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

navToggle = {
	init: ->
		# nav-content toggle behavior
		$('.js-nav-toggle').click( ->
			$('body').toggleClass('nav-open')
			return false
		)
}

paneTitle = {
	init: ->
		$('.pane--title').each( ->
			paneHeight = $(@).parents('.pane--header').height()
			$(@).width(paneHeight)
		)
}


$ ->
	navToggle.init()
	paneTitle.init()
