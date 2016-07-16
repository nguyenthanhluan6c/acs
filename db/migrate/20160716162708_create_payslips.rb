class CreatePayslips < ActiveRecord::Migration[5.0]
  def change
    create_table :payslips do |t|
      t.references :employee, foreign_key: true
      t.date :time

      t.timestamps
    end
  end
end
