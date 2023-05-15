class MessagesController < ApplicationController
  before_action :set_chat_room

  before_action :check_correct_users, only: %i[index]

  def create
    message = @chat_room.messages.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast("chat_#{@chat_room.id}", message.as_json(include: { user: { only: :username } }))
      render json: message.as_json(include: :user), status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  def index
    @messages = @chat_room.messages.includes(:user).as_json(include: { user: { only: :id } })
    user = @chat_room.user1.id != @current_user.id ? @chat_room.user1.as_json(only: [:id, :first_name, :last_name]) : @chat_room.user2.as_json(only: [:id, :first_name, :last_name])
    render json: { messages: @messages, user: user }
  end


      
  private
      
  def message_params
    params.require(:message).permit(:body)
  end

  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

  def check_correct_users
    if @current_user.id != @chat_room.user1_id &&  @current_user.id != @chat_room.user2_id
      render json:  {"error": "No access"}, status: 403
    end
  end
end
