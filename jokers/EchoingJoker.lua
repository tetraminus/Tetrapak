

local function init()
    local echoingjoker = SMODS.Joker:new(
        "Echoing Joker",
        tpmakeID("echoing_joker"),
        {
            
            extra = {
                last_hand = nil
            }
        },
        {
            x = 0,
            y = 0
        },
        {
            name = "Echoing Joker",
            text = {
                "Swaps the {C:chips}chips{} and",
                "{C:red}mult{} of your hand."
            }
        },
        3, -- rarity
        7, -- cost
        true,
        true,
        false,
        true,
        "Echoing Joker"
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("echoing_joker")] = echoingjoker
    
end

local function load_effect()

    local eval_hand_ref = evaluate_poker_hand
    function evaluate_poker_hand(eval_hand_ref)
        local hand = eval_hand_ref()
        local echoingjoker = next(find_joker("Echoing Joker"))
        if echoingjoker then
        
            if hand == "High Card" and G.GAME.last_hand_played then
                return  G.GAME.last_hand_played
            end
        end


        
        return hand
    end


    
end

return {
    init = init,
    load_effect = load_effect
    
}