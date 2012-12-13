class AnnotationsController < ApplicationController
 
  respond_to :json
 
  def index
    @annotations = Annotation.all_grouped
    respond_with(@annotations)
  end

 # POST /parts
  # POST /parts.json
  def create
  	# TODO: persist it for realz
    @annotation = Annotation.new(params[:annotation])

    respond_to do |format|
      if @annotation.save
        format.json { render json: @annotation, status: :created}
      else
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end



end