class MessagesController < ApplicationController
  def create
    @campaign_session = CampaignSession.find(params[:campaign_session_id])
    @campaign = Campaign.find(@campaign_session.campaign_id)
    @message = Message.new(message_params)
    @message.campaign_session = @campaign_session
    @message.user = current_user
    if @message.save
      CampaignSessionChannel.broadcast_to(
        @campaign_session,
        render_to_string(partial: "message", locals: {message: @message})
      )
      head :ok
    else
      render "campaign_sessions/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end