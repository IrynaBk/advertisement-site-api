class ChatRoomsController < ApplicationController
  def create
    chat_room = ChatRoom.where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)',
    params[:chat_room][:user1_id] , params[:chat_room][:user2_id], params[:chat_room][:user1_id], params[:chat_room][:user2_id]).to_a.first
    if chat_room.present?
      render json: chat_room.as_json, status: :ok
    else
      chat_room = ChatRoom.new(chat_room_params)
      if chat_room.save
        # ActionCable.server.broadcast("chat_#{chat_room.id}", chat_room.as_json)
        render json: chat_room.as_json, status: :created
      else
        render json: chat_room.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    if params[:user1_id] and params[:user2_id]
      chat_room = ChatRoom.between(params[:user1_id], params[:user2_id])
    else
      chat_room = ChatRoom.find(params[:id])
    end
    ActionCable.server.broadcast("chat_#{chat_room.id}", chat_room.messages.as_json)
    render json: chat_room.as_json(include: [:user1, :user2, :messages])
  end

  def index
    chat_rooms = ChatRoom.where('user1_id = ? OR user2_id = ?', @current_user.id, @current_user.id)
    render json: chat_rooms.as_json({:include => { 
      :user1 => { 
        :only => [:id], 
        :methods => [:full_name]
      },
      :user2 => { 
        :only => [:id], 
        :methods => [:full_name]
      }
    }})
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:user1_id, :user2_id)
  end
end
