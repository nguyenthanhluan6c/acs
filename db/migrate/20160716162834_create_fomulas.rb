class CreateFomulas < ActiveRecord::Migration[5.0]
  def change
    create_table :fomulas do |t|
      t.string :name
      t.string :display_name
      t.string :expression
      t.integer :index

      t.timestamps
    end
  end
end
