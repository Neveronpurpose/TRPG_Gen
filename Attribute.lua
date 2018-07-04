-- Attribute.lua
local Attribute = {}
Attribute.__index = Attribute
local round = math.floor

Attribute.new = function (AttributeName, Score)
    local self = {}
    local mt = setmetatable({}, Attribute)

    --> Data
    mt.name = AttributeName or "Unnamed Attribute"
    mt.abv = string.upper(string.sub(mt.name, 1, 3))
    mt.score = Score
    mt.mod = nil

    mt.init = function ()
        mt.mod = math.floor((mt.score/2)-5)
        return mt.mod
    end
    mt.init()

    --> Call the table to get mt.bonus
    mt.__call = function (self, ...)
        -- e.g. Creature.Athletics() --> +11
        return mt.score
    end

    --> print
    mt.__tostring = function ()
        local output = ""
            output = output .. mt.abv .. "\t" .. mt.score.. " ("

            if mt.mod >= 0 then
                output = output .. "+"
            end

            output = output .. mt.mod .. ")"
        return output
    end

    --> Encapsulation Functions
    mt.__index = function (t,k)
        return mt[k]
    end

    mt.__newindex = function (t,k,v)
        if mt[k] ~= nil then
            if k == 'mod' then
                print ("Reset score, then use " .. mt.name .. ".init() to reset modifier.")
                return
            elseif k == 'init' then
                print ("Cannot reset this field.")
                return
            else
                mt[k] = v
            end
        end
        mt.init()
    end

    setmetatable(self, mt)
    return self
end

return Attribute
