
local function init()

    local loc_text = {
        name = "The Unseen",
        text = {
            "When your second hand is",
            "played, gives you a curse."

        }
    }

    local data = {
        name = "The Unseen",
        key = "theunseen",
        loc_txt = loc_text,
        boss = {
            min = 1,
            max = 4
        },
        atlas = "theunseen",
        boss_colour = HEX('9800A9'),
        
    }
    
    local theunseen = SMODS.Blind(
        data
    )
    
    Tetrapak.Blinds[tpblindSlug("theunseen")] = theunseen
end


local function load_effect ()
    
    SMODS.Blinds[tpblindSlug("theunseen")].set_blind = function (self)
       self.turn = 0
    end

    SMODS.Blinds[tpblindSlug("theunseen")].press_play = function (self)

        
        self.turn = self.turn + 1
        if self.turn == 2 then
            local curse = create_card('Joker', G.jokers, nil, CURSERARITY, nil, nil,nil, 'spi')
            curse:add_to_deck()
            G.jokers:emplace(curse)
            curse:start_materialize()
         end
        
    end
    
  

end



return {
    init = init,
    load_effect = load_effect
}