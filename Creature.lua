local Ruleset = require 'Ruleset' -- a data file including campaign rules such as the skill list, scalings on stats, etc
local Attribute = require 'Attribute'
local Skill = require 'Skill'

local Creature = {}
Creature.__index = Creature
Creature.new_Skill = Skill.new

function Creature.new (params)
    --> Object Orientation Setup
    local self = {}
    local mt = setmetatable({}, Creature)
    local init = params

    --> if a role was given, get the data preset for that role
    local _ = Creature.getRole(params.role)
    if _ ~= nil then setmetatable(init, _) end

    --> DATA
        -- Header
        mt.name = init.name or "New Creature"
        mt.tags = init.tags or {"Size", "Origin", "Type", "Keywords"}
        mt.level = init.level or 0
        mt.role = init.role or "Role"
        mt.xp = init.xp or 0
        mt.alignment = init.alignment or "Neutral"
        mt.languages = init.languages or {"Common"}

        -- Status
        mt.HP = init.HP or 0
        mt.Bloodied = init.Bloodied or 0
        mt.Speed = init.Speed or 6
        mt.AP = init.AP or 0
        mt.initiative = init.initiative or 0

        -- Defenses
        mt.AC = init.AC or 0
        mt.FORT = init.FORT or 0
        mt.REF = init.REF or 0
        mt.WILL = init.WILL or 0
        mt.DefensiveTraits = init.DefensiveTraits or {}

        -- Attack Bonuses
        mt.atk_AC = init.atk_AC or 0
        mt.atk_NAD = init.atk_NAD or 0  -- "NAD: non-armor defenses"

        -- Special Traits
        mt.Aura = init.Aura or nil
        mt.Powers = init.Powers or {}

        -- Ability Scores
        mt.STR = Attribute.new("Strength", init.STR or 0)
        mt.DEX = Attribute.new("Dexterity", init.DEX or 0)
        mt.CON = Attribute.new("Constitution", init.CON or 0)
        mt.INT = Attribute.new("Intelligence", init.INT or 0)
        mt.WIS = Attribute.new("Wisdom", init.WIS or 0)
        mt.CHA = Attribute.new("Charisma", init.CHA or 0)

        -- Skills
        local list = Ruleset.MasterList_Skills
        mt.Skills = init.Skills or {}
        for i,v in ipairs(list) do
            mt[list[i][1]] = mt:new_Skill(list[i][1], list[i][2], false)
            mt.Skills[i] = mt[list[i][1]]
        end

        -- Etc
        mt.equipment = init.equipment or {}
        mt.etc = init.etc or {}

    --> Object Orientation: Encapsulation Functions
    mt.__index = function (t,k) --[[
        Universal Accessor: you can screen which values are able to be read here
    ]]--
        return mt[k]
    end
    mt.__newindex = function (t,k,v) --[[
        Universal Mutator: you can determine how each field is changed when
        another script uses the assignment operator on it (e.g., "Creature.HP = 10")
    ]]--
        -- Using assignment on an Attribute should alter its score, not
        -- replace the Attribute Object
        if k == "STR"
            or k == "DEX"
            or k == "CON"
            or k == "INT"
            or k == "WIS"
            or k == "CHA"
        then
            if type(k) == "number" then
                mt[k].score = v
            else
                print("Value " .. k .. " not changed: new value must be a number.")
                return
            end
        else -- for other existing fields, simply allow the script to change the value
            if mt[k] ~= nil then
                mt[k] = v
            else -- new fields are added to the "etc" table within the creature
                print("Added new field to Creature.etc."..k)
                mt["etc"][k] = v
            end
        end
    end

    -- tostring, for printing the entire creature to the console
    mt.__tostring = function ()
        local output = ""
        output = output ..
            mt.name .. "\t\t\t\t\tLevel " .. mt.level .. " " .. mt.role .. "\n"

        for i,v in ipairs(mt.tags) do
            output = output .. mt.tags[i] ..", "
        end

        output = output .. mt.alignment .. "\t\t\tXP " .. mt.xp .. "\n"
            .. ".............................................................\n"
            .. "   " .. "HP " .. mt.HP .. " / Bloodied " .. mt.Bloodied .. "\t\tAC " .. mt.AC .. "\n"
            .. "   " .. "Speed " .. mt.Speed .. "\t\t\tFORT " .. mt.FORT .. "\n"
            .. "   " .. "Action Points " .. mt.AP .. "\t\tREF " .. mt.REF .. "\n"
            .. "   " .. "Initiative " .. mt.initiative .. "\t\t\tWILL " .. mt.WILL .. "\n"

            if mt.Aura then output = output .. "Aura " .. mt.Aura end

            if #mt.DefensiveTraits > 0 then
                output = output .. ".............................................................\n"
                for i,v in ipairs(mt.DefensiveTraits) do
                    output = output .. mt.DefensiveTraits[i] .. ", "
                end
            end

            if #mt.Powers > 0 then
                output = output .. ".............................................................\n"
                .. "\t\t\t*POWERS*\n"
                for i,v in ipairs(mt.Powers) do
                    output = output .. mt.Powers[i] .. "\n"
                end
            end

            output = output
            .. ".............................................................\n"
            .. "   " .. tostring(mt.STR) .. "\t\t" .. tostring(mt.INT) .. "\n"
            .. "   " .. tostring(mt.DEX) .. "\t\t" .. tostring(mt.WIS) .. "\n"
            .. "   " .. tostring(mt.CON) .. "\t\t" .. tostring(mt.CHA) .. "\n"

            if #mt.Skills > 0 then
                output = output .. ".............................................................\n"
                .. "\t\t\t*SKILLS*\n"
                for i,v in ipairs(mt.Skills) do
                    if mt.Skills[i].trained == true then
                        output = output .. "   " .. tostring(mt.Skills[i]) .. "\n"
                    end
                end
            end
            if #mt.equipment > 0 then
                output = output .. ".............................................................\n"
                .. "\t\t\t*EQUIPMENT*\n"
                for i,v in ipairs(mt.equipment) do
                    output = output .. mt.equipment[i] .. "\n"
                end
            end
            if #mt.etc > 0 then
                output = output .. ".............................................................\n"
                .. "\t\t\t*OTHER*\n"
                for i,v in ipairs(mt.etc) do
                    output = output .. mt.etc[i] .. "\n"
                end
            end
            output = output .. ".............................................................\n"

        return output
    end

    setmetatable(self,mt) -- finishes object orientation setup; don't remove
    return self
end

function Creature.getRole(init_role) --[[
    determines if the role passed to the creature constructor function points
    to a creature role from the core rulebooks. If it does, and external script
    containing that role's preset data is instantiated and returned by this
    function. Otherwise, this function returns nil.
]]--
    local def_roles = {
        "Artillery",
        "Brute",
        "Controller",
        "Leader",
        "Lurker",
        "Skirmisher",
        "Solider",
        "Striker"
    }

    local role_meta = nil
    for i=1, #0def_roles do
        if init_role == def_roles[i] then
            role_meta = require(init_role)
            break
        end
    end
    return role_meta
end

return Creature
