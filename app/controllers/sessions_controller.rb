class SessionsController < ApplicationController
  skip_after_filter :store_return_to

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = "Logged in!"
      redirect_back_or_default(root_url)
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_back_or_default(root_url)
  end
end
