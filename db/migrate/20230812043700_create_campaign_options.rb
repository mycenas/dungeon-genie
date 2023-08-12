class CreateCampaignOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_options do |t|
      t.string :name
      t.string :location
      t.string :description
      t.string :image_url

      t.timestamps
    end
  end
end
