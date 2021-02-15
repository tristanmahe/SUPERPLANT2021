class Plant < ApplicationRecord
  belongs_to :user
  has_many :rentals
  has_many :users, through: :rentals
end
