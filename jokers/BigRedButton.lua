

local function init()
    local loc_text = {
        name = "Big Red Button",
        text = {
            "Reroll all your jokers and consumables."
        }
    }
    local big_red_button = SMODS.Joker:new(
        "Big Red Button",
        tpmakeID("big_red_button"),
        {
            pinned = true,
            extra = {}
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
        "Big Red Button"
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("big_red_button")] = big_red_button
    
end

local function load_effect()

    local addcard_ref = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        if self.ability.name == "Big Red Button" then
            G.GAME.used_jokers[tpjokerSlug("big_red_button")] = nil

            local jokers = G.jokers.cards
            local consumables = G.consumeables.cards
            local num_jokers = #jokers
            local legendaries = 0
            for k, v in pairs(jokers) do
                print(v.config.center.rarity)
                if v.config.center.rarity == 4 then
                    legendaries = legendaries + 1
                    num_jokers = num_jokers - 1
                end
                v:start_dissolve()
            end
            self:start_dissolve()

            
            local consumable_types = {}
            for k, v in pairs(consumables) do
                v:start_dissolve()
                consumable_types[v.ability.set] = true
    
            end



            for i = 1, num_jokers + 1 do
                play_sound('timpani')
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'brb')
                card:add_to_deck()
                G.jokers:emplace(card)
            end
            for i = 1, legendaries do
                play_sound('timpani')
                local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'brb')
                card:add_to_deck()
                G.jokers:emplace(card)
            end



            for k, v in pairs(consumable_types) do
                print(k)
                local card = create_card(k, G.consumeables, nil, nil, nil, nil, nil, 'brb')
                card:add_to_deck()
                G.consumeables:emplace(card)
            end

            
        end
        
        return addcard_ref(self,from_debuff)
    end
    
end

return {
    init = init,
    load_effect = load_effect
    
}