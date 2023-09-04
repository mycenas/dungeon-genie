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

      race = Race.find(@campaign.character.race_id).name
      character_class = CharacterClass.find(@campaign.character.character_class_id).name
      languages_str = @campaign.character.languages.join(", ")
      equipment_str = @campaign.character.equipment.join(", ")

      character_stats = CharacterStats.where(character_id: @campaign.character.id).each_with_object({}) do |stat, hash|
        stat_name = Stats.find(stat.stats_id).name
        hash[stat_name] = stat.value
      end

       # Using ChatService here
      chat_service = ChatService.new(
        message: @message.content,
        campaign_description: @campaign.campaign_option.description,
        message_history: existing_messages,
        character: {
          name: @campaign.character.name,
          level: @campaign.character.level,
          race: race,
          character_class: character_class,
          max_hp: @campaign.character.max_hp,
          current_hp: @campaign.character.current_hp,
          armor_class: @campaign.character.armor_class,
          equipment: equipment_str,
          gender: @campaign.character.gender,
          languages: languages_str,
        },
        character_stats: character_stats
      )

      generated_text = chat_service.call

      ai_message = Message.new(content: generated_text)
      ai_message.campaign_session = @campaign_session
      ai_message.user_id = 5 # Dungeon Genie user ID
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