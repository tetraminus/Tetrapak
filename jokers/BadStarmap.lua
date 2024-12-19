local function init()
    local loc_text = {
        name = "Bad Star chart",
        text = {
            "All planet cards are {C:attention}flipped{}.",
            "They upgrade hands 3 times.",
        }
    }
    local Joker = SMODS.Joker(
        {
            name = "Bad Star chart",
            key = ("bad_star_chart"),
            loc_txt = loc_text,
            rarity = 2, -- rarity
            cost = 6,   -- cost,
            blueprint_compat = true,
        }
    )

    Tetrapak.Jokers["j_" .. tpmakeID("name")] = Joker
end

local function load_effect()
    SMODS.Centers[tpjokerSlug("bad_star_chart")].calculate = function(self, card, context)
        if context.using_consumeable then
            local consumeable = context.consumeable

            if context.blueprint then
                card = context.blueprint_card
            end

            if consumeable.ability.set == "Planet" then
                consumeable:flip()
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_again_ex') })

                update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                    {
                        handname = localize(consumeable.ability.consumeable.hand_type, 'poker_hands'),
                        chips = G.GAME
                            .hands[consumeable.ability.consumeable.hand_type].chips,
                        mult = G.GAME.hands
                            [consumeable.ability.consumeable.hand_type].mult,
                        level = G.GAME.hands
                            [consumeable.ability.consumeable.hand_type].level
                    })
                level_up_hand(consumeable, consumeable.ability.consumeable.hand_type)
                update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                    { mult = 0, chips = 0, handname = '', level = '' })

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_again_ex') })

                update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                    {
                        handname = localize(consumeable.ability.consumeable.hand_type, 'poker_hands'),
                        chips = G.GAME
                            .hands[consumeable.ability.consumeable.hand_type].chips,
                        mult = G.GAME.hands
                            [consumeable.ability.consumeable.hand_type].mult,
                        level = G.GAME.hands
                            [consumeable.ability.consumeable.hand_type].level
                    })
                level_up_hand(consumeable, consumeable.ability.consumeable.hand_type)
                update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                    { mult = 0, chips = 0, handname = '', level = '' })
            end
        end
    end


    local orig_create_card = create_card

    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if _type == "Planet" and next(find_joker("Bad Star chart")) then
            skip_materialize = true
        end
        local card = orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if card.ability.set == "Planet" and next(find_joker("Bad Star chart")) then
            card.sprite_facing = 'back'
            card.facing = 'back'
            card.flipping = nil
            card.pinch.x = false
        end
        return card
    end

    local orig_CardArea_emplace = CardArea.emplace

    ---@diagnostic disable-next-line: duplicate-set-field
    function CardArea:emplace(card, location, stay_flipped)
        if card.ability.set == "Planet" and next(find_joker("Bad Star chart")) then
            stay_flipped = true
        end

        orig_CardArea_emplace(self, card, location, stay_flipped)
    end
end

return {
    init = init,
    load_effect = load_effect
}
