class RemoveUserIdFromChats < ActiveRecord::Migration[6.0]
  def change
    remove_column :chats, :user_id, :bigint
  end
end
