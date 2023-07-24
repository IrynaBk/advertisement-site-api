class ChatRoom < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages
  attr_accessor :current_user


  scope :between, -> (user1_id, user2_id) do
    where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)', user1_id, user2_id, user2_id, user1_id).to_a.first
  end

  def unread_messages_count(user)
    messages.unread_by(user).count
  end

  def current_user_unread_messages_count
    unread_messages_count(self.current_user)
  end


end
