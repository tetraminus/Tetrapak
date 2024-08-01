
local function init()
    local loc_text = {
        name = "Bad Star chart",
        text = {
            "All planet cards are {C:attention}flipped{}.",
        }
    }
    local Joker = SMODS.Joker(
        {
            name = "name",
            key = ("key"),
            loc_txt = loc_text,
            rarity = 1, -- rarity
            cost = 6, -- cost
        }
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("name")] = Joker
    
    
end

local function load_effect()
    local orig_create_card = create_card

    function create_card(...)
        local card = orig_create_card(...)
        if card.ability.set == "Planet" then
            card.facing='back'
            card.flipping = 'f2b'
        end
        return card
    end
   
    
end

return {
    init = init,
    load_effect = load_effect
}