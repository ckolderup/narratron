class PasswordRecoveriesController < ApplicationController
  def new
  end

  def create
    params.permit(:email)
    user = User.find_by_email(params[:email])

    @recovery = PasswordRecoveryToken.create(user: user)
    Mailer.send_email(user.email, "Narratron Password Recovery", render 'email')

    flash[:message] = "Thanks! An email will be sent to #{params[:email} with further
    instructions if there's an account with that email address."
    redirect_to root
  end

  def lookup
    @recovery = PasswordRecoveryToken.find(password_recovery_params)

    if @recovery.present?
      @user = @recovery.user

      render 'reset' and return
    else
      flash[:warning] = "Invalid recovery token. If you were trying to reset a password, please generate a new password recovery email."
      redirect_to root
    end
  end

  def reset
    @recovery = PasswordRecoveryToken.find(password_recovery_params)

    if @recovery.present? &&
       @recovery.user.email == params[:"user[email]"] &&
       @recovery.user.update(user_params)
    then
      @recovery.destroy

      flash[:message] = "Password reset! Please log in with your new password."
      redirect_to log_in_path
    else
      flash[:error] = "Could not reset password. If you believe this is in error, please contact feedback@narratron.com."
      redirect_to root
    end
  end

  private

  def password_recovery_params
    params.require(:password_recovery_token).permit(:token)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
end
