# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

[User, Spell, Race, CharacterClass, Stats, CampaignOption, Campaign].each do |model|
  model.destroy_all
end

# User Seeds
hieu = User.create(email: "hieu@dungeongenie.com", password: "hieu123!")
marnie = User.create(email: "marnie@dungeongenie.com", password: "momoyuki")
brian = User.create(email: "brian@dungeongenie.com", password: "brian456!")
david = User.create(email: "david@dungeongenie.com", password: "darkurge")

# Race Seeds
wood_elf = Race.create(name: "Wood Elf", description: "Wood elves are a reclusive subrace of elves ...", ability_bonuses: "+2 Dexterity, +1 Wisdom", traits: "Darkvision, ...", languages: "Common, Elvish")
dragonborn = Race.create(name: "Dragonborn", description: "Born of dragons, dragonborn display ...", ability_bonuses: "+2 Strength, +1 Charisma", traits: "Draconic Ancestry, ...", languages: "Common, Draconic")
hill_dwarf = Race.create(name: "Hill Dwarf", description: "Hill Dwarves are stout and sturdy ...", ability_bonuses: "+2 Constitution, +1 Wisdom", traits: "Darkvision, ...", languages: "Common, Dwarvish")
tiefling = Race.create(name: "Tiefling", description: "Tieflings bear the mark ...", ability_bonuses: "+2 Charisma, +1 Intelligence", traits: "Darkvision, ...", languages: "Common, Infernal")

# Class Seeds
druid = CharacterClass.create(name: "Druid", description: "Guardians of the wilderness ...", hit_die: "d8", primary_ability: "Wisdom", spellcasting_ability: "Wisdom")
cleric = CharacterClass.create(name: "Cleric", description: "Channeling the power of their deity ...", hit_die: "d8", primary_ability: "Wisdom", spellcasting_ability: "Wisdom")
warlock = CharacterClass.create(name: "Warlock", description: "Bound by a pact ...", hit_die: "d8", primary_ability: "Charisma", spellcasting_ability: "Charisma")
fighter = CharacterClass.create(name: "Fighter", description: "Masters of martial combat ...", hit_die: "d10", primary_ability: "Strength or Dexterity")

# Stats Seeds
strength = Stats.create(name: "Strength", value: 10)
dexterity = Stats.create(name: "Dexterity", value: 10)
constitution = Stats.create(name: "Constitution", value: 10)
intelligence = Stats.create(name: "Intelligence", value: 10)
wisdom = Stats.create(name: "Wisdom", value: 10)
charisma = Stats.create(name: "Charisma", value: 10)

# CampaignOption Seeds
echoes_campaign = CampaignOption.create(name: "Echoes of the Crystalline Spire", location: "The City of Lustra", description: "Lustra was once the most vibrant ...", image_url: "echoes_of_the_crystalline_spire.png")
whispers_campaign = CampaignOption.create(name: "Whispers in the Sandsea", location: "The Sandsea Deserts", description: "The endless dunes of the Sandsea ...", image_url: "whispers_in_the_sandsea.png")
veil_campaign = CampaignOption.create(name: "Veil of the Verdant Moon", location: "The floating archipelagos of Lunalia", description: "The islands of Lunalia drift gently ...", image_url: "veil_of_the_verdant_moon.png")
ironbound_campaign = CampaignOption.create(name: "The Ironbound Prophecy", location: "The metropolis of Gearford", description: "Gearford, with its sky-scraping towers ...", image_url: "the_ironbound_prophecy.png")

# Campaign Seeds

User.all.each do |user|
  sampled_campaign_options = CampaignOption.order("RANDOM()").limit(3)  # This will fetch 2 random campaign options

  sampled_campaign_options.each do |option|
    Campaign.create(
      user: user,
      campaign_option: option
    )
  end
end

# Character Seeds

def determine_image_path(race_name, class_name)
  "#{race_name.downcase}_#{class_name.downcase}.png"
end

# David

user_david = User.find_by(email: "david@dungeongenie.com")
if user_david
  character = Character.create!(
    name: "The Dark Urge",
    user: user_david,
    level: 1,
    race_id: Race.where(name: "Dragonborn").first.id,
    character_class_id: CharacterClass.where(name: "Fighter").first.id,
    max_hp: 10,
    current_hp: 10,
    armor_class: "Heavy Armor",
    gender: "Male",
    languages: ["Common", "Draconic"],
    equipment: ["Backpack", "Crowbar", "Hammer", "10 torches", "Tinderbox", "10 days of rations", "A waterskin", "50 ft of rope"],
    image_path: "dragonborn_fighter.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [17, 14, 10, 12, 8, 14]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end

# Hieu

user_hieu = User.find_by(email: "hieu@dungeongenie.com")
if user_hieu
  character = Character.create!(
    name: "Giwu",
    user: user_hieu,
    level: 1,
    race_id: Race.where(name: "Hill Dwarf").first.id,
    character_class_id: CharacterClass.where(name: "Cleric").first.id,
    max_hp: 12,
    current_hp: 12,
    armor_class: "Heavy Armor",
    gender: "Male",
    languages: ["Common", "Dwarvish", "Nerakese"],
    equipment: ["Backpack", "Crowbar", "Hammer", "10 torches", "Tinderbox", "10 days of rations", "A waterskin", "50 ft of rope"],
    image_path: "hilldwarf_cleric.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [10, 8, 16, 15, 13, 13]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end

# Brian

user_brian = User.find_by(email: "brian@dungeongenie.com")
if user_brian
  character = Character.create!(
    name: "Galgadot",
    user: user_brian,
    level: 1,
    race_id: Race.where(name: "Tiefling").first.id,
    character_class_id: CharacterClass.where(name: "Warlock").first.id,
    max_hp: 7,
    current_hp: 7,
    armor_class: "Light Armor",
    gender: "Female",
    languages: ["Common", "Infernal"],
    equipment: ["Backpack", "Crowbar", "Hammer", "10 torches", "Tinderbox", "10 days of rations", "A waterskin", "50 ft of rope"],
    image_path: "tiefling_warlock.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [13, 8, 8, 9, 11, 11]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end

# Marnie

user_marnie = User.find_by(email: "marnie@dungeongenie.com")
if user_marnie
  character = Character.create!(
    name: "Twig",
    user: user_marnie,
    level: 1,
    race_id: Race.where(name: "Wood Elf").first.id,
    character_class_id: CharacterClass.where(name: "Druid").first.id,
    max_hp: 10,
    current_hp: 10,
    armor_class: "Medium Armor",
    gender: "Female",
    languages: ["Common", "Druidic", "Elvish"],
    equipment: ["Herbalism Kit"],
    image_path: "woodelf_druid.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [8, 15, 14, 10, 16, 12]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end

user_marnie = User.find_by(email: "marnie@dungeongenie.com")
if user_marnie
  character = Character.create!(
    name: "Giwu",
    user: user_marnie,
    level: 1,
    race_id: Race.where(name: "Hill Dwarf").first.id,
    character_class_id: CharacterClass.where(name: "Cleric").first.id,
    max_hp: 12,
    current_hp: 12,
    armor_class: "Heavy Armor",
    gender: "Male",
    languages: ["Common", "Dwarvish", "Nerakese"],
    equipment: ["Backpack", "Crowbar", "Hammer", "10 torches", "Tinderbox", "10 days of rations", "A waterskin", "50 ft of rope"],
    image_path: "woodelf_druid.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [10, 8, 16, 15, 13, 13]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end

user_marnie = User.find_by(email: "marnie@dungeongenie.com")
if user_marnie
  character = Character.create!(
    name: "Galgadot",
    user: user_marnie,
    level: 1,
    race_id: Race.where(name: "Tiefling").first.id,
    character_class_id: CharacterClass.where(name: "Warlock").first.id,
    max_hp: 7,
    current_hp: 7,
    armor_class: "Light Armor",
    gender: "Female",
    languages: ["Common", "Infernal"],
    equipment: ["Backpack", "Crowbar", "Hammer", "10 torches", "Tinderbox", "10 days of rations", "A waterskin", "50 ft of rope"],
    image_path: "tiefling_warlock.png"
  )

  stats_names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
  stats_values = [13, 8, 8, 9, 11, 11]

  stats_names.each_with_index do |name, index|
    stat = Stats.find_or_create_by(name: name)
    CharacterStats.create!(character: character, stats_id: stat.id, value: stats_values[index])
  end
end
