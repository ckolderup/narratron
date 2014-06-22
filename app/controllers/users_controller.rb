class UsersController < ApplicationController
  skip_after_filter :store_return_to
  before_filter :yourself_or_admin_only, only: :show

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

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :display_name, :password, :password_confirmation)
  end

  def yourself_or_admin_only
    unless admin_access? || current_user == User.find(params[:id])
      flash[:error] == 'User profiles are currently private.'
      redirect_back_or_default(root_path)
      false
    end
    true
  end
end
