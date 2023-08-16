class AddImagePathToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :image_path, :string
  end
end
