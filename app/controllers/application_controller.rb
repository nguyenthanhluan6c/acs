class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to redirect_url
  end

  private

  def current_ability
    @current_ability ||= Ability.new current_user, params[:id]
  end

  def after_sign_in_path_for resource
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || redirect_url
    end
  end

  def redirect_url
    return new_user_session_url if current_user.nil?
    current_user.manager? ? root_url : managers_url
  end
end
