

local function init()
    local loc_text = {
        name = "Blast Shower",
        text = {
            "Sell this card to remove a random curse."
        }
    }
    local blast_shower = SMODS.Joker:new(
        "Blast Shower",
        tpmakeID("blast_shower"),
        {
            extra = {
                Removes = 1
            }
        },
        {
            x = 0,
            y = 0
        },
        loc_text,
        2, -- rarity
        6, -- cost
        true,
        true,
        false,
        false,
        "Blast Shower"
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("blast_shower")] = blast_shower
    
end

local function load_effect()

    
    SMODS.Jokers[tpjokerSlug("blast_shower")].calculate = function(card, context)
        if card.ability.name == "Blast Shower" and context.selling_self then
    
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