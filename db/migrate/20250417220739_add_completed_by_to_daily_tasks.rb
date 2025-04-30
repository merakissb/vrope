class AddCompletedByToDailyTasks < ActiveRecord::Migration[8.0]
  def change
    add_reference :daily_tasks, :completed_by, foreign_key: { to_table: :users }
  end
end
