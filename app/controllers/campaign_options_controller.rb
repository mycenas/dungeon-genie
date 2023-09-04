class CampaignOptionsController < ApplicationController
  def index
    @campaign_options = CampaignOption.includes(campaigns: :character).all
    @characters = current_user.characters
  end
end
