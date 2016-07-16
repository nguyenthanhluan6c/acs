class CreateAdminSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_settings do |t|
      t.string :name
      t.string :value
      t.integer :index

      t.timestamps
    end
  end
end
