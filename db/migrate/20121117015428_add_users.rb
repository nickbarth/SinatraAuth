class AddUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string   :email, null: true, default: ''
      t.string   :password_digest, null: true, default: ''
      t.string   :reset_token, null: true, default: ''
      t.datetime :reset_time

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
