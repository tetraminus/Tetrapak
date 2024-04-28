--- STEAMODDED HEADER
--- MOD_NAME: Tetrapak
--- MOD_ID: tetraminus.tetrapak
--- MOD_AUTHOR: [tetraminus]
--- MOD_DESCRIPTION: A Content pack for Balatro.
--- DISPLAY_NAME: Tetrapak
--- BADGE_COLOUR: 0000ff

----------------------------------------------
------------MOD CODE -------------------------

TETRAPAKID = "tetraminus.tetrapak"
CURSERARITY = (TETRAPAKID .. ":Curses")
Tetrapak = {}



function SMODS.INIT.TetrapakJokers()
    local mod = SMODS.findModByID("tetraminus.tetrapak")

    G.P_JOKER_RARITY_POOLS[CURSERARITY] = {}
    
    G.C.RARITY[CURSERARITY] = HEX("000000")

    G.localization.misc.dictionary['k_'.. CURSERARITY] = "Curse"

    local get_badge_colourref = get_badge_colour
	function get_badge_colour(key)
		local fromRef = get_badge_colourref(key)
	
		if key == 'k_' .. CURSERARITY then return HEX("aaaaaa") 
		else return fromRef end
	end


    Tetrapak.Jokers = {}

    --load all files in the jokers folder
    local jokerFiles = love.filesystem.getDirectoryItems(mod.path.."jokers")
    local jokerdefs = {}
    for k, file in pairs(jokerFiles) do
        if string.find(file, ".lua") then
            local joker = love.filesystem.load(mod.path.."jokers/"..file)()
            table.insert(jokerdefs, joker)

        end
    end


    --- DISABLE DEBUG MODE AFTER TESTING
    --G.DEBUG = true
    _RELEASE_MODE = false

    

    for k, jokerdef in pairs(jokerdefs) do
        jokerdef:init()
        
    end
    

    
    for k, joker in pairs(Tetrapak.Jokers) do
        joker:register()
    end

    for k, jokerdef in pairs(jokerdefs) do
        jokerdef:load_effect()
    end
    
    Load_atlas()

    local cansell_ref = Card.can_sell_card
    function Card:can_sell_card(context)
        if self.config.center and self.config.center.rarity == CURSERARITY then
            return false
        end
        
        return cansell_ref(self,context)
        
    end

end



function Load_atlas()

    local mod = SMODS.findModByID("tetraminus.tetrapak")

    local mirrorSprite = SMODS.Sprite:new(
        'j_mirrored_joker',
        mod.path,
        "mirrored_joker.png",
        0,
        0,
        "asset_images"
    )
    mirrorSprite:register()


    
end






