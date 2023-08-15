class CampaignsController < ApplicationController
  before_action :authenticate_user!
  def my_campaigns
    @user = current_user
    @campaigns = @user.campaigns
  end

  def index
    @campaigns = CampaignOptions.all
  end

  # def new
  #   @campaign = Campaign.new
  # end

  def create
    @option = CampaignOption.find(params[:id])
    @campaign = Campaign.new
    @campaign.user = current_user
    @campaign.campaign_option = @option
    if @campaign.save
      flash[:notice] = "campaign was successfully created!"
      redirect_to campaign_path(@campaign[:id])
    else
      render :new
    end
  end

  def show
    @campaign = CampaignOption.find(params[:id])
  end

  private

  def campaign_params
    params.require(:campaign).permit(:user, :name, :location, :description, :image_url)
  end
end
