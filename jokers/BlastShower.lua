

local function init()

    local loc_text = {
        name = "Blast Shower",
        text = {
            "Sell this card to remove a random curse."
        }
    }
    local blast_shower = SMODS.Joker(
        {
            name = "Blast Shower",
            key = "blast_shower",
            loc_txt = loc_text,
            rarity = 2, -- rarity
            cost = 4, -- cost
            config = {
                extra = {
                    Removes = 1
                }
            },
            -- make  atlas = key
            
        }

    )
    
    
    Tetrapak.Jokers[tpjokerSlug("blast_shower")] = blast_shower
    
end

local function load_effect()
    SMODS.Centers[tpjokerSlug("blast_shower")].calculate = function(self, card, context)
        if  context.selling_self then
    
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
        
        
    end
    
end

return {
    init = init,
    load_effect = load_effect
    
}