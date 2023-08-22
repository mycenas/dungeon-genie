class UserCampaignSession < ApplicationRecord
  belongs_to :user
  belongs_to :campaign_session
end
