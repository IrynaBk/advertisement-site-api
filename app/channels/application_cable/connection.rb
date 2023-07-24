require_relative '../../../lib/json_web_token.rb'

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      token = request.params[:token]
      decoded_hash = JsonWebToken.decode(token)
      if verified_user = User.find_by(id: decoded_hash["user_id"])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
