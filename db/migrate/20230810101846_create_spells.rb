class CreateSpells < ActiveRecord::Migration[7.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.integer :level
      t.string :description
      t.string :school
      t.string :casting_time
      t.string :range
      t.string :duration

      t.timestamps
    end
  end
end
