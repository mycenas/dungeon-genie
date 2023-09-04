class ChatService
  attr_reader :message, :campaign_description, :message_history

  def initialize(message:, campaign_description:, message_history: [], character:, character_stats:)
    @message = message
    @campaign_description = campaign_description
    @message_history = message_history
    @character = character
    @character_stats = character_stats
  end

  def call
    final_response = ""

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


    final_response
  end

  private

  def dm_prompts
  description = campaign_description || 'a fantasy world'
  char_info = "The main character, #{@character[:name]}, is a level #{@character[:level]} #{@character[:race]} #{@character[:character_class]}. " +
              "They have #{@character[:max_hp]} max HP, currently at #{@character[:current_hp]} HP. " +
              "Their armor class is #{@character[:armor_class]}, and they are equipped with #{@character[:equipment]}. " +
              "They are #{@character[:gender]} and can speak the following languages: #{@character[:languages]}."

  stats_info = "Their ability scores are: Strength #{@character_stats['Strength']}, Dexterity #{@character_stats['Dexterity']}, " +
               "Constitution #{@character_stats['Constitution']}, Intelligence #{@character_stats['Intelligence']}, " +
               "Wisdom #{@character_stats['Wisdom']}, Charisma #{@character_stats['Charisma']}."

  [
    "You are an AI-powered Dungeon Master for a Dungeons & Dragons campaign. Your role is to guide the players through a campaign matching this description: #{description}. 
    Introduce the main character #{char_info} to the setting, story, and whenever appropriate, ask them to roll dice to determine the outcomes of their actions.  
    Keep your responses to around 100 words max. Use the Dungeons & Dragons ruleset. 
    Make sure to ask the player to roll dice for actions like attacks, skill checks, and saving throws.
    Calculate the outcomes based on their rolls and ability scores: #{stats_info}."
  ]
end




  def client
    @_client ||= OpenAI::Client.new
  end
end
