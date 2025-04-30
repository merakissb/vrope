class CreateDailyTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_tasks do |t|
      t.references :service, null: false, foreign_key: true
      t.date :date
      t.string :name
      t.text :description
      t.boolean :completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
