class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "chat_#{params[:room]}"
    if ActionCable.server.pubsub.redis_connection_for_subscriptions.get("chat_#{params[:room]}_user_#{current_user.id}").nil?
      ActionCable.server.pubsub.redis_connection_for_subscriptions.incr("chat_#{params[:room]}_user_#{current_user.id}")
    end
  end

  def unsubscribed
    stop_all_streams
    ActionCable.server.pubsub.redis_connection_for_subscriptions.del("chat_#{params[:room]}_user_#{current_user.id}")
  end

  def receive(data)
    ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end

end