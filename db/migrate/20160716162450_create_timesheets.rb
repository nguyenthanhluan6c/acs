class CreateTimesheets < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheets do |t|
      t.date :time
      t.references :employee, foreign_key: true
      t.float :vacation_with_salary
      t.float :vacation_without_salary
      t.float :total_vacation_with_insurance_fee

      t.timestamps
    end
  end
end
