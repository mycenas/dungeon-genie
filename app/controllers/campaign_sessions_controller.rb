class CampaignSessionsController < ApplicationController
  before_action :find_campaign, only: [:create, :show]

  def create
    @campaign_session = @campaign.campaign_sessions.new

    if @campaign_session.save
      redirect_to campaign_session_path(@campaign, @campaign_session)
    else
      redirect_to @campaign, alert: "Failed to start session!"
    end
  end

  def show
    @campaign_session = @campaign.campaign_sessions.find(params[:id])
  end

  def send_message
    raise
    chat_service = ChatService.new(message: "params[:message]")
    response = chat_service.call

    respond_to do |format|
      format.json { render json: response}
      format.html
    end
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

end
