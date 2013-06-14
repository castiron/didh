class PagesController < ActionController::Base

	layout :resolve_layout

	def resolve_layout
		case action_name
			when "index"
				"frontend_home"
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
			NotificationsMailer.new_message(@message).deliver
			redirect_to(about_path, :notice => "Message was successfully sent.")
		else
			flash.now.alert = "Please fill all fields."
			render :about
		end
	end

	def news
	end

	def dynamic
		page = params[:page]
	    render page
	end

end
