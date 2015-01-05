class KeywordsController < ApplicationController

	respond_to :json

  def index
    @text = Text.find(params[:text_id])
    if params[:sentence]
      @keywords= @text.keywords.where('sentence = ?', params[:sentence])
    else
      @keywords= @text.keywords
    end
    respond_with @keywords
  end

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