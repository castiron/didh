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
    if current_user.admin?
      @text.destroy
      respond_with @text
    else
      respond_to do |format|
        format.json { render json: {}, status: :forbidden}
      end
    end
	end
end
