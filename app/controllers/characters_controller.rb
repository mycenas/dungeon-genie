class CharactersController < ApplicationController

  # GET /characters/new
  def new
    @character = Character.new
  end

  # POST /characters
  def create
    @character = Character.new(character_params)
    @character.user = current_user
    if @character.save
      # redirect to the character show page
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
