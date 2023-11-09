class ChangeRoundChatIdToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :rounds, :chat_id, :bigint
  end
end
