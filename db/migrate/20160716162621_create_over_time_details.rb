class CreateOverTimeDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :over_time_details do |t|
      t.references :overtime, foreign_key: true
      t.references :employee, foreign_key: true
      t.float :total_hour

      t.timestamps
    end
  end
end
