class ApplicationController < ActionController::Base
	protect_from_forgery

	layout :layout_by_resource

	protected

	def after_sign_in_path_for(resource_or_scope)
		if params[:redirect]
			params[:redirect]
		end
	end


	def after_sign_out_path_for(resource_or_scope)
		if params[:redirect]
			params[:redirect]
		end
	end

	def layout_by_resource
		if devise_controller?
			'admin'
		else
			'application'
		end
	end

end
