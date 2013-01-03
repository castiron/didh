	class TextsController < ApplicationController

	def index
		@texts = Text.all

		respond_to do |format|
			format.json { render json: @texts }
		end
	end

	def show
		@text = Text.find(params[:id])
		respond_to do |format|
			format.json { render json: @text }
		end
	end

	def destroy
		@text = Text.find(params[:id])
		@text.destroy

		respond_to do |format|
			format.json { head :no_content }
		end
	end
end
