class CreateServiceParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :service_participants do |t|
      t.references :service, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
