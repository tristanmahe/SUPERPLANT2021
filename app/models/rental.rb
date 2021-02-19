class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :plant

  def after_initialize
    self.answer = 'pending' unless self.answer
  end
end
