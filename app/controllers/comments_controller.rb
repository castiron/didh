class CommentsController < ApplicationController

  respond_to :json, :atom

  def index
    if params[:sentence]
      @comments = Comment.where('sentence_checksum = ?', params[:sentence])
    elsif params[:text_id]
      @text = Text.find(params[:text_id])
      @comments = @text.comments.order('created_at DESC')
    else
      @comments = Comment.order('created_at DESC').all()
    end
    respond_with @comments
  end

  def show
    @comment = Comment.find(params[:id])
    respond_with @comment
  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user.admin?
      @comment.destroy
      respond_with @comment
    else
      respond_to do |format|
        format.json { render json: {}, status: :forbidden}
      end
    end
  end

  def create
    @comment = Comment.new(comment_params)
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
