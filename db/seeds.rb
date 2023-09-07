# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

[User, Spell, Race, Character, CharacterClass, Stats, CampaignOption, Campaign].each do |model|
  model.destroy_all
end

# User Seeds
hieu = User.create(email: "hieu@dungeongenie.com", password: "hieu123!")
marnie = User.create(email: "marnie@dungeongenie.com", password: "momoyuki")
brian = User.create(email: "brian@dungeongenie.com", password: "brian456!")
david = User.create(email: "david@dungeongenie.com", password: "darkurge")
dungeongenie = User.create(email: "dungeongenie@dungeongenie.com", password: "dungeongenie")

# Race Seeds
wood_elf = Race.create(name: "Wood Elf", description: "Wood elves are a reclusive subrace of elves known for their grace and connection to nature. With skin in hues of copper and eyes reflecting the verdant forests they call home, they move silently, blending seamlessly with the woodland surroundings. As children of the forest, Wood Elves possess an innate understanding of the natural world. This bond manifests as heightened senses and nimbleness, making them exceptional scouts and hunters.", ability_bonuses: "+2 Dexterity, +1 Wisdom", traits: "Darkvision, Mask of the Wild, Fleet of Foot, Keen Senses", languages: "Common, Elvish")
dragonborn = Race.create(name: "Dragonborn", description: "Born of dragons, Dragonborn display the majesty and power of their draconic heritage. Their towering bodies are covered in fine scales, which can be of various colors corresponding to the lineage of their ancestors. With proud crests and eyes that burn with determination, they walk the world with a natural authority. Despite their intimidating presence, Dragonborn have a deep sense of honor and value loyalty above all.", ability_bonuses: "+2 Strength, +1 Charisma", traits: "Draconic Ancestry, Breath Weapon, Fire Resistance", languages: "Common, Draconic")
hill_dwarf = Race.create(name: "Hill Dwarf", description: "Hill Dwarves are stout and sturdy, characterized by their rugged builds and love for earth and stone. Residing in the rolling hills and mountainous regions, they are known for their craftsmanship and tenacity. With ruddy cheeks, deep-set eyes, and thick beards, Hill Dwarves exude resilience, taking pride in their ability to withstand challenges that would break others.", ability_bonuses: "+2 Constitution, +1 Wisdom", traits: "Darkvision, Dwarven Resilience, Dwarven Toughness, Stonecutting", languages: "Common, Dwarvish")
tiefling = Race.create(name: "Tiefling", description: "Tieflings bear the mark of a fiendish heritage that lurks in their lineage. With horns that arch back from their foreheads, tails that swish behind them, and eyes that burn with an inner flame, their appearance is a testament to their infernal descent. Often mistrusted due to their devilish appearance, Tieflings possess a unique blend of human creativity and infernal resilience, making them formidable in both magic and wit.", ability_bonuses: "+2 Charisma, +1 Intelligence", traits: "Darkvision, Hellish Resistance, Infernal Legacy, Fiendish Charm", languages: "Common, Infernal")

# Class Seeds
druid = CharacterClass.create(name: "Druid", description: "Guardians of the wilderness, Druids draw their power from the very essence of the world around them. They see the rhythm of nature, the balance of life and death, and the deep-rooted connection between all living things. With the forest as their sanctuary and animals as their allies, Druids can shift into beasts, summon the wrath of natural elements, and heal with the gentle touch of flora. Their reverence for nature isn't just philosophical; it's the core of their magical prowess. Whether they're restoring harmony to disrupted ecosystems or standing as the last line of defense against those who would desecrate sacred lands, Druids are a testament to the raw power and beauty of the natural world.", hit_die: "d8", primary_ability: "Wisdom", spellcasting_ability: "Wisdom")
cleric = CharacterClass.create(name: "Cleric", description: "Channeling the power of their deity, Clerics are the beacon of hope and healing in a tumultuous world. With divine favor, they invoke miracles—whether that means mending wounds, banishing evil, or even raising the dead. Their faith isn't just a belief but a tangible force that shields allies and smites foes. Clerics often serve as the moral compass of their parties, guided by sacred tenets and a profound desire to spread the teachings of their god. But they're not just passive preachers; with armor, shield, and holy symbol, they're formidable warriors in their own right, poised to ensure that good prevails.", hit_die: "d8", primary_ability: "Wisdom", spellcasting_ability: "Wisdom")
warlock = CharacterClass.create(name: "Warlock", description: "Bound by a pact to otherworldly entities, Warlocks wield arcane power that comes with a price. These entities, be they ancient fiends, fey lords, or eldritch horrors, grant Warlocks unique abilities in exchange for services or fealty. This relationship is both a blessing and a burden, granting them spells and eldritch invocations that can bewilder even seasoned mages. Warlocks tread the fine line between control and being controlled, constantly navigating the desires of their patrons. Their magic is intense, often manifesting as dark beams of energy, ghostly apparitions, or curses that torment enemies. Behind the enigma of a Warlock lies a tale of ambition, desperation, and the insatiable quest for power.", hit_die: "d8", primary_ability: "Charisma", spellcasting_ability: "Charisma")
fighter = CharacterClass.create(name: "Fighter", description: "Masters of martial combat, Fighters are the embodiment of discipline, strategy, and raw physical prowess. Whether they're honing their skills with a blade, a bow, or their fists, Fighters excel in any form of combat. Through rigorous training and battle experience, they learn to exploit enemy weaknesses, parry deadly blows, and deliver devastating counterattacks. Their resilience is unmatched, allowing them to outlast foes through sheer willpower and tenacity. While some may see them as mere mercenaries or soldiers, Fighters often prove to be noble protectors, strategic warlords, or champions of causes. In the cacophony of battle, the Fighter stands as a stalwart pillar, unwavering and indomitable.", hit_die: "d10", primary_ability: "Strength or Dexterity")

# Stats Seeds
strength = Stats.create(name: "Strength", value: 10)
dexterity = Stats.create(name: "Dexterity", value: 10)
constitution = Stats.create(name: "Constitution", value: 10)
intelligence = Stats.create(name: "Intelligence", value: 10)
wisdom = Stats.create(name: "Wisdom", value: 10)
charisma = Stats.create(name: "Charisma", value: 10)

# CampaignOption Seeds
echoes_campaign = CampaignOption.create(name: "Echoes of the Crystalline Spire", location: "The City of Lustra", description: " Explore the darkened heart of Lustra, a city with haunting crystalline spires that echo with ancient magics and mysteries. Discover forgotten societies, arcane artifacts, and echoes of lost love stories. Beware the reflections on the crystalline surfaces.", image_url: "echoes_of_the_crystalline_spire.png")
whispers_campaign = CampaignOption.create(name: "Whispers in the Sandsea", location: "The Sandsea Deserts", description: "Journey through the endless Sandsea dunes where voices carried by the wind tell tales of buried prophecies and forgotten empires. Encounter mystical oases, sandstorms, and riddles hidden beneath the golden grains.", image_url: "whispers_in_the_sandsea.png")
ironbound_campaign = CampaignOption.create(name: "The Ironbound Prophecy", location: "The metropolis of Gearford", description: "Gearford, a city forged in iron in a world of magic and myth, faces a prophecy as old as rust. Players must navigate intrigue in the bustling streets, secretive guilds, and the city's underbelly, where magic and machinery collide. Will they align with destiny or rewrite the future?", image_url: "the_ironbound_prophecy.png")

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