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

      # ChatGPT integration starts here
      client = OpenAI::Client.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])

      dm_message = [{ role: "user", content: @message.content }]

      chat_response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: dm_message,
          temperature: 0.7
        }
      )

      generated_text = chat_response.dig("choices", 0, "message", "content")

      # Create a new message with the generated content from ChatGPT
      ai_message = Message.new(content: generated_text)
      ai_message.campaign_session = @campaign_session
      ai_message.user = current_user
      ai_message.save

      # Broadcast the new AI-generated message
      CampaignSessionChannel.broadcast_to(
        @campaign_session,
        render_to_string(partial: "message", locals: { message: ai_message })
      )
      # ChatGPT integration ends here

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