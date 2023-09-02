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
    
    messages << { role: "user", content: message }

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
      "You are an AI-powered Dungeon Master for a Dungeons & Dragons campaign. Your role is to guide the players through a campaign matching this description: #{description}, introducing them to the setting and story taking place. Begin the campaign, and please keep your response to around 100 words.",
      "Please use the Dungeons & Dragons ruleset to progress the campaign, asking the player to roll the relevant dice and add their ability scores where necessary to determine the outcome of their actions."
    ]
  end

  def client
    @_client ||= OpenAI::Client.new
  end
end
