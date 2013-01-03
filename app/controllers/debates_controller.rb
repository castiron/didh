class DebatesController < ApplicationController

	layout "frontend"
	
	def index
		@static = false
		@text = Text::find(1)
		@texts = Text.order('sorting ASC').all
		@parts = Part::find(:all)

		if session[:hide_instructions] == true
			@hide_instructions = 1
		else
			@hide_instructions = 0
		end
	end

	def hide_instructions
		session[:hide_instructions] = true
		respond_to do |format|
			format.html { redirect_to(debates_path) }
			format.json { render json: [success: true] }
		end
	end

	def show_instructions
		session[:hide_instructions] = false
		respond_to do |format|
			format.html { redirect_to(debates_path) }
			format.json { render json: [success: true] }
		end
	end

	def show
		@static = true
		@text = Text.find(params[:id])
		@texts = Text::find(:all)
		@parts = Part::find(:all)
	end

end
