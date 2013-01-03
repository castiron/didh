class Admin::PartsController < ApplicationController

	layout "admin"
	before_filter :authenticate_admin!

	def index
		@parts = Part.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @parts }
		end
	end

	def show
		@part = Part.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @part }
		end
	end

	def new
		@part = Part.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @part }
		end
	end

	def edit
		@part = Part.find(params[:id])
	end

	def create
		@part = Part.new(params[:part])

		respond_to do |format|
			if @part.save
				format.html { redirect_to admin_part_path(@part), notice: 'Part was successfully created.' }
				format.json { render json: @part, status: :created, location: @part }
			else
				format.html { render action: "new" }
				format.json { render json: @part.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@part = Part.find(params[:id])

		respond_to do |format|
			if @part.update_attributes(params[:part])
				format.html { redirect_to admin_part_path(@part), notice: 'Part was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @part.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@part = Part.find(params[:id])
		@part.destroy

		respond_to do |format|
			format.html { redirect_to admin_parts_url }
			format.json { head :no_content }
		end
	end
end
