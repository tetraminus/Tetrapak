

local function init()
    local spoiledspaghetti = SMODS.Joker:new(
        "Spoiled Spaghetti",
        "spoiled_spaghetti",
        {
            
            extra = {
                eternal = true,
                mult = 0
            }
        },
        {
            x = 0,
            y = 0
        },
        {
            name = "Spoiled Spaghetti",
            text = {
                "{C:mult}#1# mult.{}",
                "Loses 5 {C:mult}mult{} per turn."
            
            }
        },
        CURSERARITY,
        7,
        true,
        true,
        false,
        true,
        "Spoiled Spaghetti"
    )
    
    Tetrapak.Jokers.j_spoiled_spaghetti = spoiledspaghetti
    
    
end

local function load_effect()

    function SMODS.Jokers.j_spoiled_spaghetti.calculate(card, context)
        print(SMODS.Jokers)
        if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
            card.ability.mult = card.ability.mult - 5
            print("Spoiled Spaghetti loses 5 mult")
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

    function SMODS.Jokers.j_spoiled_spaghetti.loc_def(card)
        return {
            card.ability.mult
        }
    end
    
end

return {
    init = init,
    load_effect = load_effect
}