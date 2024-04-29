


local function init()
    local Misery = SMODS.Joker:new(
        "Misery",
        tpmakeID("misery"),
        {
            extra = {Xmult = 0.5}
        },
        {
            x = 0,
            y = 0
        },
        {
            name = "Misery",
            text = {
                "{X:mult,C:white} X#1# {} Mult",
            
            }
        },
        CURSERARITY,
        0,
        true,
        true,
        false,
        true,
        "Misery"
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("misery")] = Misery
    
    
end

local function load_effect()

    SMODS.Jokers["j_" .. tpmakeID("misery")].calculate = function(card, context)
        if context.cardarea == G.jokers then
            if SMODS.end_calculate_context(context) and not context.blueprint then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end


        end
    end

    SMODS.Jokers["j_" .. tpmakeID("misery")].set_ability = function(card, initial, delay_sprites)
        card.pinned_right = true
    end

    SMODS.Jokers["j_" .. tpmakeID("misery")].set_badges = function (card, badges)
        badges[#badges+1] = create_badge('Pinned Right', HEX('77FF77'), HEX('000000'), 1.2)
    end


    SMODS.Jokers["j_" .. tpmakeID("misery")].loc_def = function(card)
        return {
            card.ability.extra.Xmult
        }
    end
    
end

return {
    init = init,
    load_effect = load_effect
}