class CreateUserAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_accounts do |t|
      t.bigint :user_id, unsigned: true, null: false
      t.string :provider,                null: false
      t.string :uid,                     null: false
      t.text   :raw_info
      t.timestamps

      t.index :user_id, unique: true
      t.index [:provider, :uid], unique: true
    end
  end
end
