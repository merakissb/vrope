class AddUndergroundFloorsToBuildings < ActiveRecord::Migration[8.0]
  def change
    add_column :buildings, :underground_floors, :integer, default: 0, null: false
  end
end
