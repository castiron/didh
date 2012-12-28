Didh.Views.Frontend ||= {}

class Didh.Views.Frontend.PaneView extends Backbone.View

	setupSubscriptions: () ->
		Backbone.Mediator.subscribe('pane:change', (position) =>
			if position == 1 || position == 2
				@goToPosition(position)
		, @);
		Backbone.Mediator.subscribe('annotator:open', () =>
			if @currentPosition == 0 then @goToPosition(1)
		, @);

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

		if @static? && @static == true && position == 0
			return false

		if @currentPosition != position
			switch position
				when 0
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
			Backbone.Mediator.publish('pane:change', position);

			@$el.animate({left: @positions[position]})