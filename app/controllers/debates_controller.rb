class DebatesController < ApplicationController

	layout "frontend"

	def index
		@static = false
		@toc = false
		if params[:data] == 'toc-open'
			@toc = true
		end
		@editions = Edition.all
		@editionId = params[:id]
		if !@editionId 
			@editionId = @editions.last.id
		end
		@text = Text.where(edition_id: @editionId).order('id ASC').first # There's probably a better way
		@texts = Text.order('sorting ASC').all
		@parts = Part.all
		@hide_instructions = check_hide_instructions()
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
		@texts = Text.all
		@parts = Part.all
		@hide_instructions = check_hide_instructions()
	end

	####################################################
	private
	####################################################

	def check_hide_instructions
		if session[:hide_instructions] == true
			@hide_instructions = 1
		else
			@hide_instructions = 0
		end
	end

end
