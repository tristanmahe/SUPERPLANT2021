class AddLatitudeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :latitude, :float
  end
end
