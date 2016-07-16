class AddEmployeeIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :employee, foreign_key: true
  end
end
