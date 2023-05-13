class User < ApplicationRecord
    require "securerandom"
    has_one_attached :image, dependent: :destroy

    has_many :messages
    has_secure_password
    has_many :advertisements
    has_many :chat_rooms
    validates :email, presence: true, allow_blank: false
    validates :password_digest, presence: true, allow_blank: false
    validates :username, presence: true, uniqueness: true, allow_blank: false
    validates :first_name, presence: true, allow_blank: false
    validates :last_name, presence: true, allow_blank: false

    def image_url
        if image.attached?
            Rails.application.routes.url_helpers.url_for(image)
        end
    end

    def generate_password_reset_token
        self.reset_token = SecureRandom.urlsafe_base64
        self.reset_token_sent_at = Time.zone.now
        save!
    end

end
