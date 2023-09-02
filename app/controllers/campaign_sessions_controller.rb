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
    @message = Message.new
  end

  # def send_message
  #   chat_service = ChatService.new(
  #       message: chat_params[:message], 
  #       campaign_description: chat_params[:campaign_description]
  #   )
  #   response = chat_service.call
  #   render json: { response: response }
  # end

  private

  # def chat_params
  #   params.permit(:message, :campaign_description, campaign_session: {})
  # end

  def find_campaign
    @campaign = Campaign.find_by(id: params[:campaign_id])
  end

end
