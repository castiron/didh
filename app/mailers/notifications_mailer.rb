class NotificationsMailer < ActionMailer::Base

	default :from => Rails.application.secrets.contact_email_from
	default :to => Rails.application.secrets.contact_email_recipient

	def new_message(message)
		@message = message
		mail(:subject => "[dhdebates.gc.cuny.edu] #{message.subject}")
	end

end
