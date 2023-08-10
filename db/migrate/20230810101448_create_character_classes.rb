class CreateCharacterClasses < ActiveRecord::Migration[7.0]
  def change
    create_table :character_classes do |t|
      t.string :name
      t.string :description
      t.string :hit_die
      t.string :primary_ability
      t.string :spellcasting_ability

      t.timestamps
    end
  end
end
