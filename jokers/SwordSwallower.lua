

local function init()
    local loc_text = {
        name = "Sword Swallower",
        text = {
            "{X:mult,C:white} X#1# {} Mult.",
            "{X:mult,C:white} +X1 {} for each",
             "curse you have."
        }
    }

    local swordswallower = SMODS.Joker:new(
        "Sword Swallower",
        tpmakeID("swordswallower"),
        {
            extra = {Xmult = 1}
        },
        {
            x = 0,
            y = 0
        },
        loc_text,
        2, -- rarity
        6, -- cost
        true,
        true,
        true,
        true,
        "Sword Swallower"
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("swordswallower")] = swordswallower
    
end

local function load_effect()

    SMODS.Jokers["j_" .. tpmakeID("swordswallower")].calculate = function(card, context)
        if context.cardarea == G.jokers and SMODS.end_calculate_context(context) then
            local num_curses = 0
            for k,v in pairs(G.jokers.cards) do
                if v.config.center.rarity == CURSERARITY then
                    num_curses = num_curses + 1
                end 
            end


            return {
                message = localize{type='variable',key='a_xmult',vars={1 + ( card.ability.extra.Xmult * num_curses)}},
                Xmult_mod = 1 + ( card.ability.extra.Xmult * num_curses)
            }
            
        end
    end

    SMODS.Jokers["j_" .. tpmakeID("swordswallower")].loc_def = function(card)
        local num_curses = 0
        if G.jokers then
            for k,v in pairs(G.jokers.cards) do
                if v.config.center.rarity == CURSERARITY then
                    num_curses = num_curses + 1
                end 
            end
        end

        local total = card.ability.extra.Xmult and 1 + (card.ability.extra.Xmult * num_curses) or 1
        
        return {
            total
        }
    end

    
    
end

return {
    init = init,
    load_effect = load_effect
    
}