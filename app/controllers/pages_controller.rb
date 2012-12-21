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
	end

	def news
	end

end
