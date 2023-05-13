class ApplicationController < ActionController::API

  before_action :authenticate_request
  
  def not_found
    render json: { error: 'not_found' }
  end

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if (header == "null" || header== "undefined") && header
      @current_user = nil
    else
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    end
  end

  def no_auth_request
    if @current_user.nil?
      render json: {error: "authorization required"}, status: :unauthorized
    end
    render status: :ok
  end

  def current_user?(id)
    return @current_user&.id == id
  end

  def current_user
    return @current_user
  end

end
