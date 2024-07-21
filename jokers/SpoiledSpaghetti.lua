

local function init()
    local loc_text = {
        name = "Spoiled Spaghetti",
        text = {
            "{C:mult}#1# mult.{}",
            "Loses 5 {C:mult}mult{} per turn."
        
        }
    }
    local spoiledspaghetti = SMODS.Joker(
        {
            name = "Spoiled Spaghetti",
            key = ("spoiled_spaghetti"),
            loc_txt = loc_text,
            rarity = CURSERARITY, -- rarity
            cost = 6, -- cost
            config = {
                extra = {mult = 0}
            }
        }
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("spoiled_spaghetti")] = spoiledspaghetti
    
    
end

local function load_effect()

    SMODS.Centers[tpjokerSlug("spoiled_spaghetti")].calculate = function(card, context)
        if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
            card.ability.mult = card.ability.mult - 5
        
            return { 
                message = localize{type='variable',key='a_mult_minus',vars={5}},
            }
        end

        if context.cardarea == G.jokers then
            if SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_mult_minus',vars={card.ability.mult}},
                    mult_mod = card.ability.mult
                }
            end


        end
    end




    SMODS.Centers[tpjokerSlug("spoiled_spaghetti")].loc_def = function(card)
        if card.ability.mult == nil then
            card.ability.mult = 0
        end
        return {
            card.ability.mult
        }
    end
    
end

return {
    init = init,
    load_effect = load_effect
}