class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :level
      t.references :race, null: false, foreign_key: true
      t.references :character_class, null: false, foreign_key: true
      t.integer :max_hp
      t.integer :current_hp
      t.string :armor_class
      t.string :equipment

      t.timestamps
    end
  end
end
