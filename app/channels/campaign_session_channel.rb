class CampaignSessionChannel < ApplicationCable::Channel
  def subscribed
    campaign_session = CampaignSession.find(params[:id])
    stream_for campaign_session
  end

end
