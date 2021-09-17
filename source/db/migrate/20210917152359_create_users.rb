# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_users
    create_sessions
  end

  private

  def create_users
    create_table :users do |t|
      t.string :login, null: false, unique: true
      t.string :email, null: false, unique: true
      t.string :encrypted_password, null: false
      t.string :salt, null: false
      t.string :name, null: false
      t.timestamps
    end
  end

  def create_sessions
    create_table :sessions do |t|
      t.bigint :user_id, null: false
      t.datetime :expiration
      t.timestamp :created_at
      t.foreign_key :users, column: :user_id
    end
  end
end
