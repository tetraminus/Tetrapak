


local function init()
    local loc_text = {
        name = "Bound",
        text = {
            "Does not give +1 joker slot",
        }
    }
    local Bound = SMODS.Joker(
        {
            name = "Bound",
            key = ("bound"),
            loc_txt = loc_text,
            rarity = CURSERARITY, -- rarity
            cost = 4, -- cost
        }
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("bound")] = Bound
    
    
end

local function load_effect()
    
end

return {
    init = init,
    load_effect = load_effect
}