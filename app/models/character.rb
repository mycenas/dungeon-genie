class Character < ApplicationRecord
  before_create :set_image_path
  before_create :set_current_hp
  belongs_to :user
  belongs_to :race
  belongs_to :character_class
  has_and_belongs_to_many :spells, join_table: 'character_spells'
  has_and_belongs_to_many :stats, join_table: 'character_stats'
  serialize :equipment, Array
  serialize :languages, Array

  validates :name, :level, :race, :character_class, :max_hp, :current_hp, :armor_class, :equipment, presence: true

    def set_image_path
        image_lookup = {
            "male_tiefling_warlock" => "male_tiefling_warlock.png",
            "female_tiefling_warlock" => "female_tiefling_warlock.png",

            "male_woodelf_druid" => "male_woodelf_druid.png",
            "female_woodelf_druid" => "female_woodelf_druid.png",

            "male_dragonborn_fighter" => "male_dragonborn_fighter.png",
            "female_dragonborn_fighter" => "female_dragonborn_fighter.png",

            "male_hilldwarf_cleric" => "male_hilldwarf_cleric.png",
            "female_hilldwarf_cleric" => "female_hilldwarf_cleric.png",
        }

        key_base = "#{self.race.name.downcase.gsub(' ', '')}_#{self.character_class.name.downcase}"

        gender_key = self.gender.downcase
        gender_key = ["male", "female"].sample if gender_key == 'other'
        
        full_key = "#{gender_key}_#{key_base}"

        self.image_path = image_lookup[full_key]
    end



  def set_current_hp
    self.current_hp = self.max_hp
  end
  
end