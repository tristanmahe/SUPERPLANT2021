class AddAnswerToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :answer, :string
  end
end
