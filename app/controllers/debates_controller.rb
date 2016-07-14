class DebatesController < ApplicationController

	layout "frontend"

	def index
		@static = false
		@toc = false
		if params[:data] == 'toc-open'
			@toc = true
		end

		# Determine edition, part, and text based on the params
		if params[:text_id]
			@text = Text.find(params[:text_id])
			@part = @text.part
			@editionId = @text.edition_id
		else
			if params[:part_id]
				@part = Part.find(params[:part_id])
				@editionId = @part.edition_id
			end
		end

		if !@editionId
			@editionId = params[:edition_id]
		end

		# If no edition is specified, show the most recent
		if !@editionId
			@editionId = @editions.last.id
		end

		@edition = Edition.find(@editionId)

		@editions = Edition.all
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
