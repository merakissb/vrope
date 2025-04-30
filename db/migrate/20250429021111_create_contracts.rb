class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.references :building, null: false, foreign_key: true
      t.decimal :price
      t.string :currency
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
