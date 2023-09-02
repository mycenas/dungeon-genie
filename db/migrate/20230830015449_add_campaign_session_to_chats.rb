class AddCampaignSessionToChats < ActiveRecord::Migration[7.0]
  def change
    add_reference :chats, :campaign_session, null: false, foreign_key: true
  end
end
