class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.index ["email"], name: "index_users_on_email", unique: true
      t.string :phone
      t.string :avatar
      t.integer :role, default: 0
      t.string :password_digest
      t.string :remember_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :activation_digest
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
  end
end
