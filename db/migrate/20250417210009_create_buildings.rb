class CreateBuildings < ActiveRecord::Migration[8.0]
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :rut
      t.string :address_reference
      t.integer :floors
      t.integer :year_built
      t.references :property_manager, null: false, foreign_key: true

      t.timestamps
    end
  end
end
