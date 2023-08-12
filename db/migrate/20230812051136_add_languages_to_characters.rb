class AddLanguagesToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :languages, :string
  end
end
