class CreateRaces < ActiveRecord::Migration[7.0]
  def change
    create_table :races do |t|
      t.string :name
      t.string :description
      t.string :ability_bonuses
      t.string :traits
      t.string :languages

      t.timestamps
    end
  end
end
