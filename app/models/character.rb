class Character < ApplicationRecord
  before_validation :set_image_path, on: :create
  before_validation :set_current_hp, on: :create
  before_validation :set_class_defaults, on: :create
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

  private

  def set_class_defaults

    stats_values = {}

    case self.character_class.name.downcase
    when 'cleric'
      self.max_hp = 10
      self.armor_class = "Heavy Armor"
      self.equipment = ["Chain Mail", "Shield", "Mace", "Holy Symbol", "Adventurer's Pack"]
      self.languages = ["Common", "Celestial"]
      stats_values = {
        "Strength" => 12,
        "Dexterity" => 10,
        "Constitution" => 14,
        "Intelligence" => 10,
        "Wisdom" => 15,
        "Charisma" => 13
      }

    when 'warlock'
      self.max_hp = 9
      self.armor_class = "Medium Armor"
      self.equipment = ["Leather Armor", "Dagger", "Spellbook", "Component Pouch", "Adventurer's Pack"]
      self.languages = ["Common", "Infernal"]
      stats_values = {
        "Strength" => 8,
        "Dexterity" => 12,
        "Constitution" => 13,
        "Intelligence" => 14,
        "Wisdom" => 10,
        "Charisma" => 16
      }

    when 'druid'
      self.max_hp = 9
      self.armor_class = "Medium Armor"
      self.equipment = ["Hide Armor", "Wooden Shield", "Scimitar", "Druidic Focus", "Adventurer's Pack"]
      self.languages = ["Common", "Elvish", "Druidic"]
      stats_values = {
        "Strength" => 10,
        "Dexterity" => 12,
        "Constitution" => 12,
        "Intelligence" => 14,
        "Wisdom" => 16,
        "Charisma" => 9
      }

    when 'fighter'
      self.max_hp = 12
      self.armor_class = "Heavy Armor"
      self.equipment = ["Chain Mail", "Longsword", "Shield", "Crossbow", "Adventurer's Pack"]
      self.languages = ["Common", "Dwarvish"]
      stats_values = {
        "Strength" => 16,
        "Dexterity" => 13,
        "Constitution" => 14,
        "Intelligence" => 10,
        "Wisdom" => 11,
        "Charisma" => 8
      }
    end

    stats_values.each do |name, value|
      stat = Stats.find_or_create_by(name: name)
      CharacterStats.create!(character: self, stats_id: stat.id, value: value)
    end
  end

  def set_current_hp
    self.current_hp = self.max_hp
  end

end
