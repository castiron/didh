class PagesController < ApplicationController

	layout :resolve_layout

	def resolve_layout
		case action_name
			when "index"
				"frontend_home"
			when "development"
				"frontend_development"
			else
				"frontend_page"
			end
	end

	def index
	end

	def book
	end

	def about
		@message = Message.new
	end

	def sendMessage
		@message = Message.new(params[:message])

		if @message.valid?
			if verify_recaptcha(:model => @message)
				NotificationsMailer.new_message(@message).deliver
				redirect_to(about_path, :notice => "Message was successfully sent.") and return
			end
		else
			flash.now.alert = "Please fill all fields."
		end
		render :about
	end

	def news
	end

	def development
		page = params[:page]
	    render page
	end

end
