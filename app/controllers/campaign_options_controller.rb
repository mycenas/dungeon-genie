class CampaignOptionsController < ApplicationController
  def index
    @campaign_options = CampaignOption.all
    @characters = current_user.characters
  end
end
