class AddGenderToCharacters < ActiveRecord::Migration[6.0] # Note: version might differ
  def change
    add_column :characters, :gender, :string
  end
end
