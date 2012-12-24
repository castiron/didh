class DebatesController < ApplicationController

	layout "frontend"
	
	def index
		@text = Text::find(1)
		@texts = Text.order('sorting ASC').all
		@parts = Part::find(:all)
	end

	def show
		@text = Text.find(params[:id])
		@texts = Text::find(:all)
		@parts = Part::find(:all)
	end

end
