class CreateCharacterStats < ActiveRecord::Migration[7.0]
  def change
    create_table :character_stats do |t|
      t.references :character, null: false, foreign_key: true
      t.references :stats, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
