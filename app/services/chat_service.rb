class ChatService
  attr_reader :message, :campaign_description, :message_history

  def initialize(message:, campaign_description:, message_history: [])
    @message = message
    @campaign_description = campaign_description
    @message_history = message_history
  end

  def call
    if message_history.empty?
      messages = dm_prompts.map { |prompt| { role: "system", content: prompt } }
      messages << { role: "system", content: "Campaign Description: #{campaign_description}" }
    else
      messages = message_history.dup
    end

    messages = dm_prompts.map do |prompt|
      { role: "system", content: prompt}
    end

    messages << { role: "system", content: "Campaign Description: #{campaign_description}"}
    messages << { role: "user", content: message}

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: messages,
        temperature: 0.7,
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  def dm_prompts
    description = campaign_description || 'a fantasy world'
    [
      "You are an AI-powered Dungeon Master for a Dungeons & Dragons campaign. Your role is to guide the players through a campaign matching this description: #{description}, introducing them to the setting and story taking place. Begin the campaign."
    ]
  end

  def client
    @_client ||= OpenAI::Client.new
  end
end
