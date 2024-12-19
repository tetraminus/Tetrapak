local function init()
    local loc_text = {
        name = "Fusion Joker",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "Can combine with itself for {X:mult,C:white}+#4#X{}.",
            "{C:attention} #2# in #3# {} chance to",
            "replace a cards in the shop",
        }
    }
    local fusionjoker = SMODS.Joker(
        {
            name = "Fusion Joker",
            key = "fusion_joker",
            loc_txt = loc_text,
            rarity = 3, -- rarity
            cost = 6,   -- cost
            config = {
                extra = {
                    Xmult = 1,
                    fusemult = 0.5,
                    chance = 5,
                    fusions = 0
                }
            }
        }
    )


    Tetrapak.Jokers[tpjokerSlug("fusion_joker")] = fusionjoker
end

local function load_effect()
    SMODS.Centers[tpjokerSlug("fusion_joker")].calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.joker_main then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end

        if context.store_card_create and not context.blueprint then
            if pseudorandom("fusionjoker") < G.GAME.probabilities.normal / card.ability.extra.chance then
                local newcard = create_card('Joker', context.area, nil, 0.9, nil, nil, tpjokerSlug("fusion_joker"), 'uta')
                create_shop_card_ui(newcard, 'Joker', context.area)
                newcard.states.visible = false
                newcard:start_materialize()

                newcard.cost = newcard.cost + math.floor(card.ability.extra.fusions / 2)

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Replaced!' })


                return newcard
            end
        end
    end

    SMODS.Centers[tpjokerSlug("fusion_joker")].loc_vars = function(self, info_queue, card)
        local probabilities = G.GAME and G.GAME.probabilities.normal or 1

        return {
            vars = {
                card.ability.extra.Xmult,
                probabilities,
                card.ability.extra.chance,
                card.ability.extra.fusemult
            }
        }
    end

    local addcard_ref = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        if self.ability.name == "Fusion Joker" then
            G.GAME.used_jokers[tpjokerSlug("fusion_joker")] = nil

            local jokers = G.jokers.cards

            local oldFusionJoker = nil
            for k, v in pairs(jokers) do
                if v.ability.name == "Fusion Joker" then
                    oldFusionJoker = v
                    break
                end
            end

            if oldFusionJoker then
                oldFusionJoker.ability.extra.Xmult = oldFusionJoker.ability.extra.Xmult + self.ability.extra.fusemult
                oldFusionJoker.ability.extra.fusions = oldFusionJoker.ability.extra.fusions + 1
                self:start_dissolve()
            end
        end

        return addcard_ref(self, from_debuff)
    end

    local check_space_ref = G.FUNCS.check_for_buy_space
    function G.FUNCS.check_for_buy_space(card)
        local jokers = G.jokers.cards

        for k, v in pairs(jokers) do
            if v.ability.name == "Fusion Joker" and card.ability.name == "Fusion Joker" then
                return true
            end
        end

        return check_space_ref(card)
    end
end

return {
    init = init,
    load_effect = load_effect

}
