class CreateFormulas < ActiveRecord::Migration[5.0]
  def change
    create_table :formulas do |t|
      t.string :name
      t.string :display_name
      t.string :expression
      t.string :index

      t.timestamps
    end
  end
end
