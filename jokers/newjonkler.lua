local function init()
    local loc_text = {
        name = "_template",
        text = {
            "do something",
        }
    }
    local Joker = SMODS.Joker(
        {
            name = "name",
            key = ("key"),
            loc_txt = loc_text,
            rarity = 1, -- rarity
            cost = 6,   -- cost
        }
    )


    -- uncomment to add the joker image
    -- Tetrapak.Jokers["j_" .. tpmakeID("name")] = Joker
end

local function load_effect()

end

return {
    init = init,
    load_effect = load_effect
}
