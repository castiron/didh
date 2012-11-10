class DebatesController < ApplicationController

	layout "frontend"
	
	def index
		@text = Text::find(1)
	end

end
