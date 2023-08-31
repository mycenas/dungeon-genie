class CampaignSession < ApplicationRecord
  belongs_to :campaign
  has_many :messages, dependent: :destroy
  # has_many :user_campaign_sessions
  # has_many :users, through: :user_campaign_sessions
end
