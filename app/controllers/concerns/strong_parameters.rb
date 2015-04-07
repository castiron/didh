module StrongParameters
  extend ActiveSupport::Concern

  included do

    # If we're in a devise controller, whitelist some parameters
    before_filter :configure_permitted_parameters, if: :devise_controller?

  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :first_name
    devise_parameter_sanitizer.for(:account_update) << :last_name
    devise_parameter_sanitizer.for(:account_update) << :settings
    devise_parameter_sanitizer.for(:account_update) << :city
    devise_parameter_sanitizer.for(:account_update) << :state
    devise_parameter_sanitizer.for(:account_update) << :country
    devise_parameter_sanitizer.for(:account_update) << :gender
  end

  protected

  def message_params
    params.permit(:name, :email, :subject, :body)
  end

  def annotation_params
    params.require(:annotation).permit(:sentence, :text_id, :type)
  end

  def comment_params
    params.require(:comment).permit(:body, :author_name, :author_email, :sentence_checksum, :text_id, :parent_id)
  end

  def keyword_params
    params.require(:keyword).permit(:sentence, :word, :text_id)
  end

end
