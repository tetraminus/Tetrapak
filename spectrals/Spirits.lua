

local function init()
    local loc_text = {
        name = "Spirits",
        text = {
            "Gain a {C:dark_edition}Negative{}, {C:green}Uncommon{} Joker.",
            "Gain a {C:".. CURSERARITY .. "}Curse{}"
        }
    }

    local data ={
        name = "Spirits",
        key = tpmakeID("spirits"),
        set = "Spectral",
        loc_txt = loc_text,
    
    }

    local Spirits = SMODS.Consumable(data)


    Tetrapak.Spectrals[tpmakeID("spirits")] = Spirits
    
    
end

local function load_effect()
    
        SMODS.Centers[tpconsumableSlug("spirits")].use = function(card, area, copier)
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

        SMODS.Centers[tpconsumableSlug("spirits")].can_use = function(card)
            return true
        end
    
end

return {
    init = init,
    load_effect = load_effect
}