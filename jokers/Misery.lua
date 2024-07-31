


local function init()
    local loc_text = {
        name = "Misery",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
        
        }
    }
    local Misery = SMODS.Joker(
        {
            name = "Misery",
            key = ("misery"),
            loc_txt = loc_text,
            rarity = CURSERARITY, -- rarity
            cost = 6, -- cost
            config = {
                extra = {Xmult = 0.5}
            }
        }
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("misery")] = Misery
    
    
end

local function load_effect()

    SMODS.Centers[tpjokerSlug("misery")].calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.joker_main and not context.blueprint then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end


        end
    end

    SMODS.Centers[tpjokerSlug("misery")].set_ability = function(self, card, initial, delay_sprites)
        card.pinned_right = true
    end

    SMODS.Centers[tpjokerSlug("misery")].set_badges = function (self, card, badges)
        badges[#badges+1] = create_badge('Pinned Right', HEX('77FF77'), HEX('000000'), 1.2)
    end
    

    SMODS.Centers[tpjokerSlug("misery")].loc_vars = function(self, _info, card)
        return {
            vars ={
                card.ability.extra.Xmult
            }
            
        }
    end
    
end

return {
    init = init,
    load_effect = load_effect
}