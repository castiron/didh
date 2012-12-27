Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.PaneView extends Backbone.View

	toggleOpen: (e) ->
		if e then e.stopPropagation()
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

		if !recursionBuster? then recursionBuster = false
		if @linkedPane && recursionBuster == false
			if position == 2
				@linkedPane.goToPosition(2, true)
			if position == 1 && @currentPosition == 2
				@linkedPane.goToPosition(1, true)

		if @currentPosition != position
			switch position
				when 0
					@annotator.stopAnnotating()
					@$el.find('.js-content-nav--pos1-show').hide()
					@$el.find('.js-content-nav--pos2-show').hide()
					@$el.find('.js-content-nav--pos0-show').show()
					$('body').addClass('nav-open')
				when 1
					@$el.find('.js-content-nav--pos0-show').hide()
					@$el.find('.js-content-nav--pos2-show').hide()
					@$el.find('.js-content-nav--pos1-show').show()
					$('body').addClass('nav-open')
				when 2
					@$el.find('.js-content-nav--pos0-show').hide()
					@$el.find('.js-content-nav--pos1-show').hide()
					@$el.find('.js-content-nav--pos2-show').show()
					$('body').removeClass('nav-open')

			@currentPosition = position

			@$el.animate({left: @positions[position]})