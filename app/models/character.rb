class Character < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :character_class
  has_and_belongs_to_many :spells, join_table: 'character_spells'
  has_and_belongs_to_many :stats, join_table: 'character_stats'
  serialize :weapons, Array
  serialize :equipment, Array
  serialize :languages, Array

  validates :name, :level, :race, :character_class, :max_hp, :current_hp, :armor_class, :equipment, presence: true
end