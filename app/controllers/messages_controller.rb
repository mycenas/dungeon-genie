class MessagesController < ApplicationController
  def create
    @campaign_session = CampaignSession.find(params[:campaign_session_id])
    @campaign = Campaign.find(@campaign_session.campaign_id)
    @message = Message.new(message_params)
    @message.campaign_session = @campaign_session
    @message.user = current_user

    # Fetch existing messages from the database
    existing_messages = @campaign_session.messages.order(:created_at).map do |msg|
      { role: msg.user == current_user ? "user" : "system", content: msg.content }
    end

    if @message.save
      CampaignSessionChannel.broadcast_to(
        @campaign_session,
        render_to_string(partial: "message", locals: {message: @message})
      )

       # Using ChatService here
      chat_service = ChatService.new(
        message: @message.content,
        campaign_description: @campaign.campaign_option.description,
        message_history: existing_messages
      )

      generated_text = chat_service.call

      ai_message = Message.new(content: generated_text)
      ai_message.campaign_session = @campaign_session
      ai_message.user = current_user # Change this to Dungeon Genie user later on
      ai_message.save

      CampaignSessionChannel.broadcast_to(
        @campaign_session,
        render_to_string(partial: "message", locals: { message: ai_message })
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