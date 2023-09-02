class ChatService
  attr_reader :message, :campaign_description, :message_history

  def initialize(message:, campaign_description:, message_history: [])
    @message = message
    @campaign_description = campaign_description
    @message_history = message_history
  end

  def call
    final_response = "" # Variable to hold the final response

    if message_history.empty?
      messages = dm_prompts.map { |prompt| { role: "system", content: prompt } }
      messages << { role: "system", content: "Campaign Description: #{campaign_description}" }
    else
      messages = message_history.dup
    end
    
    messages << { role: "user", content: message }

    client.chat(
    parameters: {
      model: "gpt-4",
      messages: messages,
      temperature: 0.7,
      stream: proc do |chunk, _bytesize|
        # Concatenate the received chunks to build the final response.
        content_chunk = chunk.dig("choices", 0, "delta", "content")
        final_response += content_chunk unless content_chunk.nil?
      end
    }
  )


    final_response # Return the final response
  end

  private

  def dm_prompts
    description = campaign_description || 'a fantasy world'
    [
      "You are an AI-powered Dungeon Master for a Dungeons & Dragons campaign. Your role is to guide the players through a campaign matching this description: #{description}. Introduce them to the setting, story, and whenever appropriate, ask them to roll dice to determine the outcomes of their actions. Keep your responses to around 100 words max. Use the Dungeons & Dragons ruleset. Make sure to ask the player to roll dice for actions like attacks, skill checks, and saving throws. Calculate the outcomes based on their rolls and ability scores.",
    ]
  end


  def client
    @_client ||= OpenAI::Client.new
  end
end
