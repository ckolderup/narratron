class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  after_filter :store_return_to

  protected

  def authorize
    unless current_user && current_user.admin?
      flash[:error] = "Unauthorized access"
      redirect_back_or_default(root_path)
      false
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def allow_story_creation
    unless current_user && current_user.story_creator?
      flash[:error] = "Unauthorized access"
      redirect_back_or_default(root_path)
      false
    end
  end

  private

  def controller_slug
    @controller_slug ||= "#{ params[:controller] }-#{ params[:action ]}"
  end
  helper_method :controller_slug

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def store_return_to
    session[:return_to] = request.url
  end
end
