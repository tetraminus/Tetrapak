--- STEAMODDED HEADER
--- MOD_NAME: Tetrapak
--- MOD_ID: tetraminus_tetrapak
--- MOD_AUTHOR: [tetraminus]
--- MOD_DESCRIPTION: A Content pack for Balatro.
--- DISPLAY_NAME: Tetrapak
--- BADGE_COLOUR: 3333aa

----------------------------------------------
------------MOD CODE -------------------------

TETRAPAKID = "tetraminus_tetrapak"

tpmakeID = function(id)
    return TETRAPAKID .. "_" .. id
end

tpjokerSlug = function(id)
    return "j_" .. tpmakeID(id)
end

tpconsumableSlug = function(id)
    return "c_" .. tpmakeID(id)
end

CURSERARITY = tpmakeID("Curses")


Tetrapak = {}



function SMODS.INIT.TetrapakJokers()
    
    local mod = SMODS.findModByID(TETRAPAKID)

    G.P_JOKER_RARITY_POOLS[CURSERARITY] = {}
    
    G.C.RARITY[CURSERARITY] = HEX("444444")

    G.localization.misc.dictionary['k_'.. CURSERARITY] = "Curse"

    local loc_colour_ref = loc_colour
    function loc_colour(key)
        if key == CURSERARITY then return HEX("444444")
        else return loc_colour_ref(key) end
    end


    local get_badge_colourref = get_badge_colour
	function get_badge_colour(key)
		local fromRef = get_badge_colourref(key)
	
		if key == 'k_' .. CURSERARITY then return HEX("444444") 
		else return fromRef end
	end


    Tetrapak.Jokers = {}
    Tetrapak.Spectrals = {}

    --load all files in the jokers folder
    local jokerFiles = love.filesystem.getDirectoryItems(mod.path.."jokers")
    local jokerdefs = {}
    for k, file in pairs(jokerFiles) do
        if string.find(file, ".lua") then
            local joker = love.filesystem.load(mod.path.."jokers/"..file)()
            table.insert(jokerdefs, joker)

        end
    end

    -- load all files in the spectrals folder
    local spectralFiles = love.filesystem.getDirectoryItems(mod.path.."spectrals")
    local spectraldefs = {}
    for k, file in pairs(spectralFiles) do
        if string.find(file, ".lua") then
            local spectral = love.filesystem.load(mod.path.."spectrals/"..file)()
            table.insert(spectraldefs, spectral)
        end
    end




    --- DISABLE DEBUG MODE AFTER TESTING
    --G.DEBUG = true
    _RELEASE_MODE = false

    

    for k, jokerdef in pairs(jokerdefs) do
        jokerdef:init()
        
    end

    for k, spectraldef in pairs(spectraldefs) do
        spectraldef:init()
    end
    

    
    for k, joker in pairs(Tetrapak.Jokers) do
        joker:register()
    end

    for k, spectral in pairs(Tetrapak.Spectrals) do
        spectral:register()
    end

    for k, jokerdef in pairs(jokerdefs) do
        jokerdef:load_effect()
    end

    for k, spectraldef in pairs(spectraldefs) do
        spectraldef:load_effect()
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

    local mod = SMODS.findModByID(TETRAPAKID)
    local sprites = {}

    -- jokers
    local spritesFiles = love.filesystem.getDirectoryItems(mod.path.."assets/1x/jokers")
   

    for k, file in pairs(spritesFiles) do
        if string.find(file, ".png") then

            name = string.sub(file, 1, string.len(file) - 4)

            local sprite = SMODS.Sprite:new(
                tpjokerSlug(name),
                mod.path,
                "jokers/" .. file,
                0,
                0,
                "asset_atli"
            )

            table.insert(sprites, sprite)
            print("Loaded sprite: " .. file)

        end
    end

    -- spectrals
    local spritesFiles = love.filesystem.getDirectoryItems(mod.path.."assets/1x/spectrals")

    for k, file in pairs(spritesFiles) do
        if string.find(file, ".png") then

            name = string.sub(file, 1, string.len(file) - 4)

            local sprite = SMODS.Sprite:new(
                tpconsumableSlug(name),
                mod.path,
                "spectrals/" .. file,
                0,
                0,
                "asset_atli"
            )

            table.insert(sprites, sprite)
            print("Loaded sprite: " .. file)

        end
    end



    for k, sprite in pairs(sprites) do
        sprite:register()
    end
end






