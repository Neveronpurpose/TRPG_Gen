local Ruleset = {}
Ruleset.__index = Ruleset

Ruleset.MasterList_Skills = {
    {"Acrobatics", "DEX"},
    {"Arcana",  "INT"},
    {"Athletics", "STR"},
    {"Bluff", "CHA"},
    {"Diplomacy", "CHA"},
    {"Dungeoneering", "WIS"},
    {"Endurance", "CON"},
    {"Heal", "WIS"},
    {"History", "INT"},
    {"Intimidate", "CHA"},
    {"Nature", "WIS"},
    {"Perception", "WIS"},
    {"Religion", "INT"},
    {"Stealth", "DEX"},
    {"Streetwise", "CHA"},
    {"Thievery", "DEX"}
}

Ruleset.MasterList_Attributes = {
    "Strength",
    "Dexterity",
    "Constitution",
    "Intelligence",
    "Wisdom",
    "Charisma"
}

return Ruleset
