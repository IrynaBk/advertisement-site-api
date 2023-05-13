class ChatRoom < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages

  scope :between, -> (user1_id, user2_id) do
    where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)', user1_id, user2_id, user2_id, user1_id).to_a.first
  end
end
