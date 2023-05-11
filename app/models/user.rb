class User < ApplicationRecord
    require "securerandom"
    has_one_attached :image, dependent: :destroy

    has_secure_password
    has_many :advertisements
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

end
