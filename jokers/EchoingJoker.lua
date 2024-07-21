

local function init()
    local loc_text = {
        name = "Echoing Joker",
        text = {
            "High Cards count as the last hand played",
            "{C:inactive}Currently: #1#{}"
        }
    }
    local echoingjoker = SMODS.Joker(
        {
            name = "Echoing Joker",
            key = ("echoing_joker"),
            loc_txt = loc_text,
            rarity = 3, -- rarity
            cost = 6, -- cost
        }
    )
    
    
    Tetrapak.Jokers["j_" .. tpmakeID("echoing_joker")] = echoingjoker
    
end

local function load_effect()

    

    SMODS.Centers[tpjokerSlug("echoing_joker")].loc_def = function (self, player)
        local var
        if G.Game and G.GAME.last_hand_played then
            var = G.GAME.last_hand_played
        else
           var =  "None"
        end
        return {
            
            var
     
        }
    end



    local eval_hand_ref = evaluate_poker_hand
    function evaluate_poker_hand(hand)
        
        local hand = eval_hand_ref(hand)
        local echoingjoker = next(find_joker("Echoing Joker"))
        if echoingjoker and G.GAME.last_hand_played then
            
            -- if hand["High Card"] and top is the only entry in the table, then it is the only hand played
            print(table.tostring(hand))
            local num = 0
            for k, v in pairs(hand) do
                if #v ~= 0 then
                    num = num + 1
                end
            end
            if num == 2 then
                hand[G.GAME.last_hand_played] = hand["High Card"]
            end


        end
        return hand
    end


    
end

return {
    init = init,
    load_effect = load_effect
    
}