function (lv, caste)
    local attribute_offset = 18
    for i=46, -9, -5 do
        if lv > i then
            break
        end
        attribute_offset = attribute_offset - 2
    end

    local caste = caste or nil
    if caste then
        -- ??? some stuff related to caste, like hp and damage
    end

    local init = {
        AC = 12+lv,
        FORT = 12+lv,
        REF = 12+lv,
        WILL = 12+lv,
        atk_AC = 7+lv,
        atk_FORT = 5+lv,
        atk_REF= 5+lv,
        atk_WILL = 5+lv,
        STR = 8+attribute_offset,
        DEX = 18+attribute_offset,
        CON = 10+attribute_offset,
        INT = 16+attribute_offset,
        WIS = 12+attribute_offset,
        CHA = 14+attribute_offset
    }
    return init
end
