

local function init()
    local loc_text = {
        name = "Mirrored Joker",
        text = {
            "Swaps the {C:chips}chips{} and",
            "{C:red}mult{} of your hand."
        }
    }

    local mirroredjoker = SMODS.Joker:new(
        "Mirrored Joker",
        tpmakeID("mirrored_joker"),
        {
            pinned = true,
            extra = {}
        },
        {
            x = 0,
            y = 0
        },
        loc_text,
        3, -- rarity
        6, -- cost
        true,
        true,
        true,
        true,
        "Mirrored Joker"
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("mirrored_joker")] = mirroredjoker
    
end

local function load_effect()

    SMODS.Jokers["j_" .. tpmakeID("mirrored_joker")].calculate = function(card, context)
        if context.cardarea == G.jokers and SMODS.end_calculate_context(context) then
            local currChips =  hand_chips
            local currMult = mult

            hand_chips = currMult
            mult = currChips
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})

            return {
              
                message = "Swapped!",
    
            }
        end
    end

    
    
end

return {
    init = init,
    load_effect = load_effect
    
}