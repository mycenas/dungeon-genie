class RemoveColumnsFromCampaigns < ActiveRecord::Migration[6.0] # Note: version might differ
  def change
    remove_column :campaigns, :name, :string
    remove_column :campaigns, :location, :string
    remove_column :campaigns, :string, :string
    remove_column :campaigns, :description, :string
    remove_column :campaigns, :image_url, :string
    remove_column :campaigns, :act, :string
  end
end
