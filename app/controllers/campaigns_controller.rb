class CampaignsController < ApplicationController
  before_action :authenticate_user!
  def my_campaigns
    @user = current_user
    @campaigns = @user.campaigns
    @campaign_options = @campaigns.map do |campaign|
    campaign.campaign_option
    end
  end

  # def new
  #   @campaign = Campaign.new
  # end

  def create
    @option = CampaignOption.find(params[:campaign_id])
    @campaign = Campaign.new
    @campaign.user = current_user
    @campaign.campaign_option = @option
    if @campaign.save
      redirect_to campaign_path(@campaign[:id])
    else
      render :new
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  private

  def campaign_params
    params.require(:campaign).permit(:user, :name, :location, :description,)
  end
end
