class ChatService
  def initialize(message:, campaign_description:, message_history: [], character:, character_stats:)
    @message = message
    @campaign_description = campaign_description
    @message_history = message_history
    @character = character
    @character_stats = character_stats
  end

  def call
    response = client.messages.create(
      model: "claude-sonnet-4-6",
      max_tokens: 500,
      system: dm_system_prompt,
      messages: build_messages
    )
    response.content.first.text
  end

  private

  def build_messages
    messages = @message_history.dup
    messages << { role: "user", content: @message }
    messages
  end

  def dm_system_prompt
    char_info = "The main character, #{@character[:name]}, is a level #{@character[:level]} " \
                "#{@character[:race]} #{@character[:character_class]}. " \
                "They have #{@character[:max_hp]} max HP, currently at #{@character[:current_hp]} HP. " \
                "Their armor class is #{@character[:armor_class]}, and they are equipped with #{@character[:equipment]}. " \
                "They are #{@character[:gender]} and can speak the following languages: #{@character[:languages]}."

    stats_info = "Their ability scores are: Strength #{@character_stats['Strength']}, " \
                 "Dexterity #{@character_stats['Dexterity']}, Constitution #{@character_stats['Constitution']}, " \
                 "Intelligence #{@character_stats['Intelligence']}, Wisdom #{@character_stats['Wisdom']}, " \
                 "Charisma #{@character_stats['Charisma']}."

    "You are an AI-powered Dungeon Master for a Dungeons & Dragons campaign. " \
    "Your role is to guide the player through a campaign matching this description: #{@campaign_description}. " \
    "Introduce the main character #{char_info} to the setting and story. " \
    "Keep your responses to around 100 words max. Use the Dungeons & Dragons ruleset. " \
    "Make sure to ask the player to roll dice for any action they make such as an attack, skill checks, and saving throws. " \
    "Calculate the outcomes based on their rolls and ability scores: #{stats_info}."
  end

  def client
    @_client ||= Anthropic::Client.new
  end
end
