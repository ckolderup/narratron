class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  protected

  def authorize
    unless current_user && current_user.is_admin?
      flash[:error] = "Unauthorized access"
      redirect_to root_path
      false
    end
  end

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
