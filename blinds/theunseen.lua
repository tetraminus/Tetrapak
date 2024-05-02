
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
        slug = tpmakeID("theunseen"),
        loc_txt = loc_text,
        dollars = 5,
        mult = 2,
        pos = {x = 0, y = 0},
        boss = {
            min = 1,
            max = 10
        },
        color = HEX('aaa0aa'),
        boss_colour = HEX('aa04aa'),
        defeated = true,
        
        
    }
    
    local theunseen = SMODS.Blind:new(
        data.name,
        data.slug,
        data.loc_txt,
        data.dollars,
        data.mult,
        nil,
        nil,
        data.pos,
        data.boss,
        data.boss_colour,
        data.defeated,
        tpblindSlug("theunseen")
    )
    
    Tetrapak.Blinds[tpblindSlug("theunseen")] = theunseen
end


local function load_effect ()
    
    SMODS.Blinds[tpblindSlug("theunseen")].set_blind = function (blind, reset, silent)
        blind.turn = 0
    end

    SMODS.Blinds[tpblindSlug("theunseen")].press_play = function (blind)
        
        blind.turn = blind.turn + 1
        if blind.turn == 2 then
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