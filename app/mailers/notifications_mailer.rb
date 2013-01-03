class NotificationsMailer < ActionMailer::Base

	default :from => "noreply@dhdebates.gc.cuny.edu"
	default :to => "dhdebates@gmail.com"

	def new_message(message)
		@message = message
		mail(:subject => "[dhdebates.gc.cuny.edu] #{message.subject}")
	end

end