-- Skill.lua
local Skill = {}
Skill.__index = Skill
local round = math.floor

Skill.new = function (Creature, SkillName, Ability, Trained)
    local self = {}
    local mt = setmetatable({}, Skill)

    --> Data
    mt.bonus = 0
    mt.name = SkillName or "Unnamed Skill"
    mt.abil = Ability or "STR"
    mt.trained = Trained or false

    mt.init = function ()
        mt.bonus = Creature[mt.abil].mod
        if mt.trained then
            mt.bonus = round(mt.bonus + 5)
        end
    end
    mt.init()

    --> Call the table to get mt.bonus
    mt.__call = function (self, ...)
        -- e.g. Creature.Athletics() --> +11
        mt.init()
        return mt.bonus
    end

    --> Encapsulation Functions
    mt.__index = function (t,k)
        mt.init()
        return mt[k]
    end

    mt.__newindex = function (t,k,v)
        if mt[k] ~= nil then -- can't add new fields to this table
            if k == "bonus" then
                -- can't reset bonus manually
                print ("Use " .. mt.name .. ".init()  to reset this skill's bonus.")
                return
            elseif k == 'init' then
                print ("Cannot reset this field.")
                return
            else
                -- ok to reset name, abil, and trained
                mt[k] = v
            end
        end
    end

    mt.__tostring = function ()
        local output = ""
            output = output .. mt.name .. " (" .. mt.abil .. ") "
            if mt.bonus >= 0 then output = output .. "+" end
            output = output .. mt.bonus
        return output
    end

    setmetatable(self, mt)
    return self
end

return Skill
