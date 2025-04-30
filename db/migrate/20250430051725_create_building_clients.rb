class CreateBuildingClients < ActiveRecord::Migration[8.0]
  def change
    create_table :building_clients do |t|
      t.references :user, null: false, foreign_key: true
      t.references :building, null: false, foreign_key: true

      t.timestamps
    end
  end
end
