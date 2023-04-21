require_relative '../../lib/json_web_token.rb'

class AuthenticationController < ApplicationController

    def login
        @user = User.find_by_username(params[:username])
        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          user_data = @user.to_json(except: [:created_at, :updated_at, :password, :password_confirmation, :password_digest])
          render json: { token: token,
                         user: user_data }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end
    
      private
    
      def login_params
        params.permit(:username, :password)
      end
end
