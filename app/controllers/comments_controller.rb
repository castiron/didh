class CommentsController < ApplicationController

  respond_to :json

  def index
    @text = Text.find(params[:text_id])
    if params[:sentence]
      @comments = @text.comments.where('sentence_checksum = ?', params[:sentence])
    else
      @comments = @text.comments
    end
    respond_with @comments
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_with(@comment)
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment, status: :created, location: '' }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

end
