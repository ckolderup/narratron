class UsersController < ApplicationController
  skip_after_filter :store_return_to

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:message] = "Details updated!"
      redirect_back_or_default(user_path(@user))
    else
      render "edit"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies.permanent.signed[:user_id] = @user.id
      flash[:message] = "Signed up!"
      redirect_back_or_default(root_url)
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
    @updating = true
    @user.password = ''
  end

  def show
    @user = User.find(params[:id])
    @contributions = Entry.where(user: @user)
                          .paginate(page: params[:page])
                          .order('created_at DESC')

    if current_user && (current_user.admin? || current_user == @user)
      render 'show'
    else
      flash[:error] == 'User profiles are currently private.'
      redirect_back_or_default(root_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :display_name, :password, :password_confirmation)
  end
end
