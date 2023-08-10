class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_sessions

  validates :name, :location, :description, :image_url, :act, presence: true
end
