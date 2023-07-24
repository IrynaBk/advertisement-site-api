class ChatRoomsController < ApplicationController
  def create
    chat_room = ChatRoom.where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)',
    params[:chat_room][:user1_id] , params[:chat_room][:user2_id], params[:chat_room][:user1_id], params[:chat_room][:user2_id]).to_a.first
    if chat_room.present?
      render json: chat_room.as_json, status: :ok
    else
      chat_room = ChatRoom.new(chat_room_params)
      if chat_room.save
        ActionCable.server.broadcast("notification_#{another_user_id(chat_room)}", { message: "#{current_user.first_name} #{current_user.last_name} created chat with you"})
        render json: chat_room.as_json, status: :created
      else
        render json: chat_room.errors, status: :unprocessable_entity
      end
    end
  end

  def show # не юзається????
    if params[:user1_id] and params[:user2_id]
      chat_room = ChatRoom.between(params[:user1_id], params[:user2_id])
    else
      chat_room = ChatRoom.find(params[:id])
    end
    chat_room.messages.unread_by(current_user).update_all(unread: false)
    byebug
    ActionCable.server.broadcast("chat_#{chat_room.id}", chat_room.messages.as_json)
    render json: chat_room.as_json(include: [:user1, :user2, :messages])
  end

  def index
    chat_rooms = ChatRoom.where('user1_id = ? OR user2_id = ?', @current_user.id, @current_user.id)
    chat_rooms.each do |chat_room|
      chat_room.current_user = @current_user
    end
    render json: chat_rooms.as_json(
      methods: :current_user_unread_messages_count, 
      include: {
        user1: {
          only: [:id],
          methods: [:full_name]
        },
        user2: {
          only: [:id],
          methods: [:full_name]
        }
      }
    )
  end

  private


  def chat_room_params
    params.require(:chat_room).permit(:user1_id, :user2_id)
  end
end
