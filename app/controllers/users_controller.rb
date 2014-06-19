class UsersController < ApplicationController
  skip_after_filter :store_return_to

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Signed up!"
      redirect_back_or_default(root_url)
    else
      render "new"
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
