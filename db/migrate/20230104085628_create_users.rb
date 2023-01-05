class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, default: ''
      t.string :uid, null: false, default: '', index: { unique: true }
      t.timestamps
    end
  end
end
