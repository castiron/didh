class KeywordsController < ApplicationController
 
	respond_to :json
 
	def create
		@keyword = Keyword.new(params[:keyword])

		respond_to do |format|
			if @keyword.save
				format.json { render json: @keyword, status: :created, location: text_keyword_url(@keyword.text, @keyword) }
			else
				format.json { render json: @keyword.errors, status: :unprocessable_entity }
			end
		end
	end

end