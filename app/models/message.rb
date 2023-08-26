class Message < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :campaign_session

  validates :content, presence: true
end
