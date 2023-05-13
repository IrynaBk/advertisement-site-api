class PasswordResetController < ApplicationController

  before_action :authenticate_request, except: [:create, :update]

  def create
    user = User.find_by(email: params[:email])
    if user
      UserMailer.password_reset_email(user).deliver_now
      render json: { message: 'Password reset email sent' }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find_by(reset_token: params[:token])
    if user && user.reset_token_sent_at > 2.hours.ago
      user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render json: { message: 'Password successfully updated' }
    elsif user && user.reset_token_sent_at < 2.hours.ago
      render json: { error: 'Password reset link has expired' }, status: :unprocessable_entity
    else
      render json: { error: 'Invalid password reset link' }, status: :unprocessable_entity
    end
  end
end
