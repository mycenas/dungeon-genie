class CharactersController < ApplicationController
  before_action :authenticate_user!

  def my_characters
    @user = current_user
    @characters = @user.characters
  end

  # GET /characters/new
  def new
    @character = Character.new
  end

  # POST /characters
  def create
    @character = Character.new(character_params)
    @character.user = current_user

    if @character.valid?
      set_character_stats(@character)
    end

    if @character.save
      redirect_to my_characters_path, notice: "#{@character.name} was successfully created."
    else
      render :new
    end
  end

  # GET /characters/:id
  def show
    @character = Character.find(params[:id])
  end

  private

  def set_character_stats(character)
    stats_values = character.send(:stats_defaults)

    stats_values.each do |name, value|
      stat = Stats.find_or_create_by(name: name)
      CharacterStats.create!(character: character, stats_id: stat.id, value: value)
    end
  end

  # strong parameters for character
  def character_params
    params.require(:character).permit(:user, :name, :level, :race_id, :character_class_id, :max_hp, :current_hp, :armor_class, :gender, :languages, :equipment)
  end
end
