class CampaignsController < ApplicationController
  before_action :authenticate_user!

  def my_campaigns
    @user = current_user
    @campaigns = @user.campaigns
    @campaign_options = @campaigns.map do |campaign|
      campaign.campaign_option
    end
  end

  def create
    @option = CampaignOption.find(params[:campaign_id])
    @character = Character.find(params[:character_id])
    
    @campaign = Campaign.new(
      user: current_user,
      campaign_option: @option,
      character: @character
    )
    
    if @campaign.save
      redirect_to campaign_path(@campaign.id)
    else
      render :new
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    @existing_session = CampaignSession.where(campaign_id: @campaign.id).last
  end

  private

  def campaign_params
    params.require(:campaign).permit(:user, :name, :location, :description)
  end
end
