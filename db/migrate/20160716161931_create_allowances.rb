class CreateAllowances < ActiveRecord::Migration[5.0]
  def change
    create_table :allowances do |t|
      t.string :name

      t.timestamps
    end
  end
end
