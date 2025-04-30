class RemoveCompletedFromDailyTasks < ActiveRecord::Migration[8.0]
  def change
    remove_column :daily_tasks, :completed, :boolean
  end
end
