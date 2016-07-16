class CreateAllowanceDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :allowance_details do |t|
      t.references :level, foreign_key: true
      t.references :employee, foreign_key: true
      t.references :allowance, foreign_key: true

      t.timestamps
    end
  end
end
