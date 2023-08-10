class Message < ApplicationRecord
  belongs_to :user
  belongs_to :campaign_session
end
