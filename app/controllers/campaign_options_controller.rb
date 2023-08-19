class CampaignOptionsController < ApplicationController
  def index
    @campaigns = CampaignOption.all
  end
end
