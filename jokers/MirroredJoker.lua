local function init()
    local loc_text = {
        name = "Mirrored Joker",
        text = {
            "Swaps the {C:chips}chips{} and",
            "{C:red}mult{} of your hand."
        }
    }

    local mirroredjoker = SMODS.Joker(
        {
            name = "Mirrored Joker",
            key = ("mirrored_joker"),
            loc_txt = loc_text,
            rarity = 2, -- rarity
            cost = 6,   -- cost
        }
    )


    Tetrapak.Jokers["j_" .. tpmakeID("mirrored_joker")] = mirroredjoker
end

local function load_effect()
    SMODS.Centers[tpjokerSlug("mirrored_joker")].calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local currChips = hand_chips
            local currMult = mult

            hand_chips = currMult
            mult = currChips
            update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })

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
