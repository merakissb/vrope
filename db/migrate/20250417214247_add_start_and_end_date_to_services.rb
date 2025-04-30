class AddStartAndEndDateToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :start_date, :datetime
    add_column :services, :end_date, :datetime
  end
end
