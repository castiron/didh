class SentencesController < ApplicationController

  respond_to :json

  def index
    @text = Text.find(params[:text_id])
    @sentences= @text.sentences
    respond_with(@sentences)
  end

  def show
    @sentence = Sentence.find(params[:id])
    respond_to do |format|
      format.json { render json: @sentence }
    end
  end


end