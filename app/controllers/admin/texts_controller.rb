class Admin::TextsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  def index
    @texts = Text.order('sorting ASC').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @texts }
    end
  end

  def show
    @text = Text.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @text }
    end
  end

  def new
    @text = Text.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text }
    end
  end

  def edit
    @authors = Author.all
    @text = Text.find(params[:id])
  end

  def create
    @text = Text.new(params[:text])

    respond_to do |format|
      if @text.save
        format.html { redirect_to admin_text_path(@text), notice: 'Text was successfully created.' }
        format.json { render json: @text, status: :created, location: @text }
      else
        format.html { render action: "new" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @text = Text.find(params[:id])

    respond_to do |format|
      if @text.update_attributes(params[:text])
        format.html { redirect_to admin_text_path(@text), notice: 'Text was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @text = Text.find(params[:id])
    @text.destroy

    respond_to do |format|
      format.html { redirect_to admin_texts_url }
      format.json { head :no_content }
    end
  end
end
