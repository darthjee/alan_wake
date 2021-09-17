class AddGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name, null: false, index: true, limit: 100
      t.bigint :user_id, null: false
      t.timestamps

      t.foreign_key :users, column: :user_id
    end
  end
end
