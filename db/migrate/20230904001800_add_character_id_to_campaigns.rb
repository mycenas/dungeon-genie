class AddCharacterIdToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :character_id, :bigint
    add_index :campaigns, :character_id
    add_foreign_key :campaigns, :characters
  end
end
