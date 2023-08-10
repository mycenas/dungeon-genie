class CampaignSession < ApplicationRecord
  belongs_to :campaign
  has_many :messages
end
