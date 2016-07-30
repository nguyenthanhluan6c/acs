class CreateColumns < ActiveRecord::Migration[5.0]
  def change
    create_table :columns do |t|
      t.string :name
      t.string :display_name
      t.string :table_expression
      t.string :index

      t.timestamps
    end
  end
end
