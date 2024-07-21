


local function init()
    local loc_text = {
        name = "Torn Pocket",
        text = {
            "Gain {C:attention}50%{} less money.",
        }
    }
    local TornPocket = SMODS.Joker(
        {
            name = "Torn Pocket",
            key = ("torn_pocket"),
            loc_txt = loc_text,
            rarity = CURSERARITY, -- rarity
            cost = 6, -- cost
        }
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("torn_pocket")] = TornPocket
    
    
end

local function load_effect()
    local original_ease_dollars = ease_dollars

    -- based on Fiendish Joker from Bunco

    function ease_dollars(mod, instant)

        if G.jokers ~= nil then
            for _, v in ipairs(G.jokers.cards) do
                if v.ability.name == "Torn Pocket" and not v.debuff and mod > 0 then
                    mod = math.ceil(mod * 0.5)
                    v:juice_up(1, 0.5)
                end
            end
        end

        original_ease_dollars(mod, instant)
    end
    
end

return {
    init = init,
    load_effect = load_effect
}