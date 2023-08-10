class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :location
      t.string :string
      t.string :description
      t.string :image_url
      t.string :act

      t.timestamps
    end
  end
end
