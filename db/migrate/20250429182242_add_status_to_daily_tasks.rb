class AddStatusToDailyTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :daily_tasks, :status, :integer
  end
end
