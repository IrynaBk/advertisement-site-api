class Message < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user

  scope :unread_by, -> (user) { where(unread: true).where.not(user_id: user.id) }

end
