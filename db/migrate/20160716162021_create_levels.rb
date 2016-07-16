class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.integer :level
      t.float :value
      t.references :allowance, foreign_key: true

      t.timestamps
    end
  end
end
