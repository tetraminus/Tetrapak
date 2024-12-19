local function init()
    local loc_text = {
        name = "Sword Swallower",
        text = {
            "{X:mult,C:white} X#1# {} Mult.",
            "{X:mult,C:white} +X1 {} for each",
            "curse you have."
        }
    }

    local swordswallower = SMODS.Joker(
        {
            name = "Sword Swallower",
            key = ("swordswallower"),
            loc_txt = loc_text,
            rarity = 2, -- rarity
            cost = 6,   -- cost
            config = {
                extra = { Xmult = 1 }
            }
        }
    )


    Tetrapak.Jokers["j_" .. tpmakeID("swordswallower")] = swordswallower
end

local function load_effect()
    SMODS.Centers[tpjokerSlug("swordswallower")].calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local num_curses = 0
            for k, v in pairs(G.jokers.cards) do
                if v.config.center.rarity == CURSERARITY then
                    num_curses = num_curses + 1
                end
            end


            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + (card.ability.extra.Xmult * num_curses) } },
                Xmult_mod = 1 + (card.ability.extra.Xmult * num_curses)
            }
        end
    end

    SMODS.Centers[tpjokerSlug("swordswallower")].loc_vars = function(self, _info, card)
        local num_curses = 0
        if G.jokers then
            for k, v in pairs(G.jokers.cards) do
                if v.config.center.rarity == CURSERARITY then
                    num_curses = num_curses + 1
                end
            end
        end

        local total = card.ability.extra.Xmult and 1 + (card.ability.extra.Xmult * num_curses) or 1

        return {
            vars = {
                total
            }
        }
    end
end

return {
    init = init,
    load_effect = load_effect

}
