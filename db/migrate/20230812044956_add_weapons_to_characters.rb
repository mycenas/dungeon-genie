class AddWeaponsToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :weapons, :string
  end
end
