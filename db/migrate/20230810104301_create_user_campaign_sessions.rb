class CreateUserCampaignSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_campaign_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
