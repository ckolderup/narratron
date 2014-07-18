module UsersHelper
  def user_form_submit_button_text(user = nil)
    if current_user
      "Update#{' your' if current_user == user} profile"
    else
      "Sign up"
    end
  end
end
