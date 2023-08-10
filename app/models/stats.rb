class Stats < ApplicationRecord
  has_and_belongs_to_many :characters, join_table: 'character_stats'
end
