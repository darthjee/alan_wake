class SetUserFieldSizes < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :login, :string, null: false, limit: 50
    change_column :users, :email, :string, null: false, limit: 100
    change_column :users, :salt, :string, null: false, limit: 32
    change_column :users, :encrypted_password, :string, null: false, limit: 64
    change_column :users, :name, :string, null: false, limit: 100

    add_index :users, :login, unique: true
    add_index :users, :email, unique: true
  end

  def down
    change_column :users, :login, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :salt, :string, null: false
    change_column :users, :encrypted_password, :string
    change_column :users, :name, :string, null: false

    remove_index :users, :login
    remove_index :users, :email
  end
end
