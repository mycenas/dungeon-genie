class RemoveWeaponsFromCharacters < ActiveRecord::Migration[7.0]
  def change
    remove_column :characters, :weapons, :string
  end
end
