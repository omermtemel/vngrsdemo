class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :lastname
      t.string :phone
      t.references :user

      t.timestamps
    end
    add_index :contacts, :user_id
  end
end
