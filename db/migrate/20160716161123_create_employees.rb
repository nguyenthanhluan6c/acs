class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.boolean :insurance
      t.string :personal_deduction
      t.integer :number_of_dependence
      t.float :base_salary, limit: 53
      t.references :category

      t.timestamps
    end
  end
end
