class CampaignOptionsController < ApplicationController
  def index
    @campaign_options = CampaignOption.all
  end
end
