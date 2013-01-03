class AnnotationsController < ApplicationController
 
	respond_to :json
 
	def index
		@annotations = Annotation.all_grouped
		respond_with(@annotations)
	end

	def show
		@annotation = Annotation.find(params[:id])

		respond_to do |format|
			format.json { render json: @annotation }
		end
	end

	def create
		@annotation = Annotation.new(params[:annotation])
		@annotation.ip = request.remote_ip

		respond_to do |format|
			if @annotation.save
				format.json { render json: @annotation, status: :created, location: text_annotation_url(@annotation.text, @annotation) }
			else
				format.json { render json: @annotation.errors, status: :unprocessable_entity }
			end
		end
	end



end