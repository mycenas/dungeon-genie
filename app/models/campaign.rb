class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :campaign_option
  has_many :campaign_sessions, dependent: :destroy
  belongs_to :character
end
