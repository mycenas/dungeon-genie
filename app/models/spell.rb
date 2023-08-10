class Spell < ApplicationRecord
  has_many :character_spells
  has_and_belongs_to_many :characters, join_table: 'character_spells'
end
