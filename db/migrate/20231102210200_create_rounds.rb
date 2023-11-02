class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.integer :chat_id
      t.boolean :active

      t.timestamps
    end
  end
end
