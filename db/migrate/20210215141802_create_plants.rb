class CreatePlants < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :species
      t.string :Status
      t.string :Pricing
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
