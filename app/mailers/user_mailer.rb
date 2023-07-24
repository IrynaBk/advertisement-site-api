class UserMailer < ApplicationMailer
    def password_reset_email(user)
      @user = user
      user.generate_password_reset_token
      @password_reset_url = password_reset_url(@user.reset_token)
      mail(to: user.email, subject: "Reset your password")
    end

    private

  def password_reset_url(token)
    "http://127.0.0.1:3001/reset_password/#{token}"
  end
  end