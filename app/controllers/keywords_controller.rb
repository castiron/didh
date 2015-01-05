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
		p = params.require(:keyword).permit(:sentence, :word, :text_id)
		@keyword = Keyword.new(p)
		respond_to do |format|
			if @keyword.save
				format.json { render json: @keyword, status: :created, location: nil }
			else
				format.json { render json: @keyword.errors, status: :unprocessable_entity }
			end
		end
	end

end