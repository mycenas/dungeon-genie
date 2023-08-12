class AddCampaignOptionToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_reference :campaigns, :campaign_option, null: false, foreign_key: true
  end
end
