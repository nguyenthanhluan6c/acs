class CreatePayslipDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :payslip_details do |t|
      t.references :payslip, foreign_key: true
      t.references :formula, foreign_key: true
      t.integer :detail_type
      t.string :result

      t.timestamps
    end
  end
end
