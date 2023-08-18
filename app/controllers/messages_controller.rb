class MessagesController < ApplicationController
  before_action :set_chat_room

  before_action :check_correct_users, only: %i[index]

  def create
    message = @chat_room.messages.new(message_params)
    message.user = current_user
    message.unread = true
    another_user = another_user_id(@chat_room)
    if !ActionCable.server.pubsub.redis_connection_for_subscriptions.get("chat_#{@chat_room.id}_user_#{another_user}").nil?      
      message.unread = false
    end
    if message.save
      ActionCable.server.broadcast("chat_#{@chat_room.id}", message.as_json(include: { user: { only: :username } }))
      render json: message.as_json(include: :user), status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  def index
      page_number = params[:page] || 1
      last_message_timestamp = params[:last_message_timestamp]

      if last_message_timestamp
        @messages = @chat_room.messages.where("created_at < ?", last_message_timestamp).order(created_at: :desc).paginate(page: page_number, per_page: 30)
      else
        @messages = @chat_room.messages.order(created_at: :desc).paginate(page: page_number, per_page: 30)
      end
  
      @messages = @messages.includes(:user).as_json(include: { user: { only: :id } })
    
      user = @chat_room.user1.id != @current_user.id ? @chat_room.user1.as_json(only: [:id, :first_name, :last_name]) : @chat_room.user2.as_json(only: [:id, :first_name, :last_name])
    
      @chat_room.messages.unread_by(current_user).update_all(unread: false)
    
      render json: { messages: @messages.reverse, user: user }
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
