

local function init()
    local loc_text = {
        name = "Cleanse",
        text = {
            "Removes #1# curse."
        }
    }

    local data = {
        name = "Cleanse",
        key = tpmakeID("cleanse"),
        set = "Spectral",
        config = {
            extra = {
                Removes = 1
            }
        },
        
        loc_txt = loc_text,
    }

    local Cleanse = SMODS.Consumable(data)

    Tetrapak.Spectrals[tpmakeID("cleanse")] = Cleanse
    
    
end

local function load_effect()
    
        SMODS.Centers[tpconsumableSlug("cleanse")].use = function(self, card, area, copier)
            local eligible_strength_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and v.config.center.rarity == CURSERARITY then
                    table.insert(eligible_strength_jokers, v)
                end
            end

            for i = 1, card.ability.extra.Removes do
                if #eligible_strength_jokers > 0 then
                    local idx = pseudorandom("cleanse", 1, #eligible_strength_jokers)
                    local joker = eligible_strength_jokers[idx]
                    joker:start_dissolve()
                    table.remove(eligible_strength_jokers, idx)
                end
            end
        end

        SMODS.Centers[tpconsumableSlug("cleanse")].can_use = function(self, card)
            local eligible_strength_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and v.config.center.rarity == CURSERARITY then
                    table.insert(eligible_strength_jokers, v)
                end
                
            end

            

            return #eligible_strength_jokers > 0
        end

        SMODS.Centers[tpconsumableSlug("cleanse")].loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.Removes
                },
                
            }
        end


    
end

return {
    init = init,
    load_effect = load_effect
}