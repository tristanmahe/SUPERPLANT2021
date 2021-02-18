class Plant < ApplicationRecord
  belongs_to :user
  has_many :rentals
  has_many :users, through: :rentals
  has_one_attached :photo

  include PgSearch::Model

  pg_search_scope :search_by_species_and_status,
  against: [ :species, :status],
  using: {
    tsearch: { prefix: true}
  }
end
