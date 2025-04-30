class RemoveYearBuiltFromBuildings < ActiveRecord::Migration[8.0]
  def change
    remove_column :buildings, :year_built, :integer
  end
end
