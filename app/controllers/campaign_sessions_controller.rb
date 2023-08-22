class CampaignSessionsController < ApplicationController
  before_action :find_campaign, only: [:new, :create]

  def new
    @campaign_session = @campaign.campaign_sessions.new
  end

  def create
    @campaign_session = @campaign.campaign_sessions.new
    if @campaign_session.save
      # connect the user to this session
      UserCampaignSession.create(user: current_user, campaign_session: @campaign_session)
      redirect_to campaign_session_path(@campaign_session)
    else
      render :new
    end
  end

  def show
    @campaign_session = CampaignSession.find(params[:id])
    @messages = @campaign_session.messages
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
