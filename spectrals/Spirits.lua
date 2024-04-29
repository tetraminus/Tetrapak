

local function init()

    local data ={
        name = "Spirits",
        slug = tpmakeID("spirits"),
        config = {
            extra = {
                
            }
        },
        pos = {
            x = 0,
            y = 0
        },
        loc_text = {
            name = "Spirits",
            text = {
                "Gain a {C:dark_edition}Negative{}, {C:green}Uncommon{} Joker.",
                "Gain a {C:".. CURSERARITY .. "}Curse{}"
            }
        
        },
        cost = 6,
        discovered = true

    }

    local Spirits = SMODS.Spectral:new(data.name, data.slug, data.config, data.pos, data.loc_text, data.cost, true, data.discovered)


    Tetrapak.Spectrals[tpmakeID("spirits")] = Spirits
    
    
end

local function load_effect()
    
        SMODS.Spectrals[tpconsumableSlug("spirits")].use = function(card, area, copier)
            local newjoker = create_card('Joker', G.jokers, nil, 0.75, nil, nil, nil, 'spi')
            newjoker:add_to_deck()
            G.jokers:emplace(newjoker)
            newjoker:set_edition({negative = true})
            newjoker:start_materialize()

            local curse = create_card('Joker', G.jokers, nil, CURSERARITY, nil, nil,nil, 'spi')
            curse:add_to_deck()
            G.jokers:emplace(curse)
            curse:start_materialize()
        end

        SMODS.Spectrals[tpconsumableSlug("spirits")].can_use = function(card)
            return true
        end
    
end

return {
    init = init,
    load_effect = load_effect
}