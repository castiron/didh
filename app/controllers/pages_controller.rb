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
		@editions = Edition.all
	end

	def book
		# placeholder until there is a second edition in database?
		@editions = Edition.all
		@edition = Edition.find(params[:id])
	end

	def about
		@editions = Edition.all
		@aboutText = Text.where('edition_id=2' ).last.id
		@message = Message.new
	end

	def sendMessage
		@editions = Edition.all
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
