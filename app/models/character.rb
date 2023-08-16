class Character < ApplicationRecord
  before_create :set_image_path
  belongs_to :user
  belongs_to :race
  belongs_to :character_class
  has_and_belongs_to_many :spells, join_table: 'character_spells'
  has_and_belongs_to_many :stats, join_table: 'character_stats'
  serialize :weapons, Array
  serialize :equipment, Array
  serialize :languages, Array

  validates :name, :level, :race, :character_class, :max_hp, :current_hp, :armor_class, :equipment, presence: true

  def set_image_path
        image_lookup = {
            "tiefling_warlock" => "tiefling_warlock.png",
            "dragonborn_fighter" => "dragonborn_fighter.png",
            "hilldwarf_cleric" => "hilldwarf_cleric.png",
            "woodelf_druid" => "woodelf_druid.png"
        }
        key = "#{self.race.name.downcase}_#{self.character_class.name.downcase}"
        self.image_path = image_lookup[key]
    end

end