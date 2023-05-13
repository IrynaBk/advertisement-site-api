class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "chat_#{params[:room]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end
end