class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :plants
  has_one_attached :photo
  geocoded_by :address
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_validation :geocode, if: :will_save_change_to_address?
end
