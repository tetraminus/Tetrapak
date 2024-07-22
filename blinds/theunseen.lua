
local function init()

    local loc_text = {
        name = "The Unseen",
        text = {
            "When your second hand is",
            "played, gives you a curse."

        }
    }
B
    local data = {
        name = "The Unseen",
        key = "theunseen",
        loc_txt = loc_text,
        boss = {
            min = 1,
            max = 4
        },
        atlas = "tetrapak_theunseen"
        
        
    }
    
    local theunseen = SMODS.Blind(
        data
    )
    
    Tetrapak.Blinds[tpblindSlug("theunseen")] = theunseen
end


local function load_effect ()
    
    SMODS.Blinds[tpblindSlug("theunseen")].set_blind = function (blind, reset, silent)
        blind.turn = 0
    end

    local debuff_hand_ref = Blind.debuff_hand

    function Blind:debuff_hand(cards, hand, handname, check)


        if self.name == "The Unseen" then
            if check and self.turn == 1 then
                return true
            end

            if not check then
                self.turn = self.turn + 1
                if self.turn == 2 then
                    local curse = create_card('Joker', G.jokers, nil, CURSERARITY, nil, nil,nil, 'spi')
                    curse:add_to_deck()
                    G.jokers:emplace(curse)
                    curse:start_materialize()
                end
            end
        end

        return debuff_hand_ref(self, cards, hand, handname, check)
        
    end

    
  

end



return {
    init = init,
    load_effect = load_effect
}