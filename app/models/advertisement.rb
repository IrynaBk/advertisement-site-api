class Advertisement < ApplicationRecord
  belongs_to :user
  scope :filter_by_search, ->(search) { 
    where("title LIKE :search OR description LIKE :search", search: "%#{search}%")
  }
end
