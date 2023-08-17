class CharactersController < ApplicationController
  before_action :authenticate_user!
  
  def my_characters
    @user = current_user
    @characters = @user.characters
  end

  # GET /characters/new
  def new
    @character = Character.new(level: 1)
  end

  # POST /characters
  def create
    @character = Character.new(character_params)
    @character.user = current_user
    if @character.save
      redirect_to character_path(@character), notice: "#{@character.name} was successfully created."
    else
      render :new
    end
  end

  # GET /characters/:id
  def show
    @character = Character.find(params[:id])
  end

  private

  # strong parameters for character
  def character_params
    params.require(:character).permit(:user, :name, :level, :race_id, :character_class_id, :max_hp, :current_hp, :armor_class, :gender, :languages, :equipment, :weapons)
  end
end
