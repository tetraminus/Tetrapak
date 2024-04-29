

local function init()

    local data ={
        name = "Cleanse",
        slug = tpmakeID("cleanse"),
        config = {
            extra = {
                Removes = 1
            }
        },
        pos = {
            x = 0,
            y = 0
        },
        loc_text = {
            name = "Cleanse",
            text = {
                "Removes #1# curse."
            }
        
        },
        cost = 6,
        discovered = true

    }

    local Cleanse = SMODS.Spectral:new(data.name, data.slug, data.config, data.pos, data.loc_text, data.cost, true, data.discovered)


    Tetrapak.Spectrals[tpmakeID("cleanse")] = Cleanse
    
    
end

local function load_effect()
    
        SMODS.Spectrals[tpconsumableSlug("cleanse")].use = function(card, area, copier)
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

        SMODS.Spectrals[tpconsumableSlug("cleanse")].can_use = function(card)
            local eligible_strength_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and v.config.center.rarity == CURSERARITY then
                    table.insert(eligible_strength_jokers, v)
                end
                
            end

            

            return #eligible_strength_jokers > 0
        end

        SMODS.Spectrals[tpconsumableSlug("cleanse")].loc_def = function(center, info)
            return {
                center.config.extra.Removes
            }
        end


    
end

return {
    init = init,
    load_effect = load_effect
}