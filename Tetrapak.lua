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

tpvoucherSlug = function(id)
    return "v_" .. tpmakeID(id)
end

CURSERARITY = tpmakeID("Curses")


Tetrapak = {}



function SMODS.INIT.TetrapakJokers()


    Load_Config()
    Load_atlas()
    
    local mod = SMODS.findModByID(TETRAPAKID)

    G.P_JOKER_RARITY_POOLS[CURSERARITY] = {}
    
    G.C.RARITY[CURSERARITY] = HEX("444444")

    G.localization.misc.dictionary['k_'.. CURSERARITY] = "Curse"
    G.localization.descriptions.Other[tpmakeID('curse_tip')] = {
        name = "Curse",
        text = {
            "This card is cursed.",
            "It cannot be sold.",
            "+1 Joker slot"
        }
    }

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
    Tetrapak.Vouchers = {}

    --load all files in the jokers folder
    local jokerFiles = love.filesystem.getDirectoryItems(mod.path.."jokers")
    local jokerdefs = {}
    for k, file in pairs(jokerFiles) do
        lowercasename = string.sub(file, 1, string.len(file) - 4):lower()

        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[lowercasename] then
            local joker = love.filesystem.load(mod.path.."jokers/"..file)()

            table.insert(jokerdefs, joker)

        end
    end

    -- load all files in the spectrals folder
    local spectralFiles = love.filesystem.getDirectoryItems(mod.path.."spectrals")
    local spectraldefs = {}
    for k, file in pairs(spectralFiles) do
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[string.sub(file, 1, string.len(file) - 4):lower()] then
            local spectral = love.filesystem.load(mod.path.."spectrals/"..file)()
            table.insert(spectraldefs, spectral)
        end
    end
    
    -- load all files in the vouchers folder
    local voucherFiles = love.filesystem.getDirectoryItems(mod.path.."vouchers")
    local voucherdefs = {}
    for k, file in pairs(voucherFiles) do
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[string.sub(file, 1, string.len(file) - 4):lower()] then
            local voucher = love.filesystem.load(mod.path.."vouchers/"..file)()
            table.insert(voucherdefs, voucher)
        end
    end

    -- place voucherdefs in the correct order by the after field, ex: after = "emptycage"
    local function sort_voucherdefs(a, b)
        if a.after == b.name then
            print("aligned")
            return true
        end
        return false
    end

    table.sort(voucherdefs, sort_voucherdefs)
    



    --- DISABLE DEBUG MODE AFTER TESTING
    --G.DEBUG = true
    _RELEASE_MODE = false

    

    for _, jokerdef in pairs(jokerdefs) do
        jokerdef:init()
    end

    for _, spectraldef in pairs(spectraldefs) do
        spectraldef:init()
    end

    for _, voucherdef in pairs(voucherdefs) do
        voucherdef:init()
    end

    for _, joker in pairs(Tetrapak.Jokers) do
        joker:register()
    end

    for _, spectral in pairs(Tetrapak.Spectrals) do
        spectral:register()
    end

    for _, voucher in pairs(Tetrapak.Vouchers) do
        voucher:register()
    end

    for _, jokerdef in pairs(jokerdefs) do
        jokerdef:load_effect()
    end

    for _, spectraldef in pairs(spectraldefs) do
        spectraldef:load_effect()
    end

    for _, voucherdef in pairs(voucherdefs) do
        voucherdef:load_effect()
    end

    
    

    local cansell_ref = Card.can_sell_card
    function Card:can_sell_card(context)
        if self.config.center and self.config.center.rarity == CURSERARITY then
            return false
        end
        
        return cansell_ref(self,context)
        
    end

    local add_to_deck_ref = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        add_to_deck_ref(self, from_debuff)
       
        if self.config.center.rarity == CURSERARITY and (not from_debuff) and self.ability.name ~= "Bound" then

            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
        return 
    end

    local remove_from_deck_ref = Card.remove_from_deck
    function Card:remove_from_deck(from_debuff)
        remove_from_deck_ref(self, from_debuff)

        
        if self.config.center.rarity == CURSERARITY and (not from_debuff)  and self.added_to_deck and self.ability.name ~= "Bound" then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        end
        return 
    end
    -- add curse tooltips
    for k, v in pairs(SMODS.Jokers) do
        if v.rarity == CURSERARITY then
            local old_tooltip = v.tooltip
            v.tooltip = function (_c, info_queue)
                if old_tooltip then
                    old_tooltip(_c, info_queue)
                end
                table.insert(info_queue, { set = 'Other', key = tpmakeID('curse_tip'), vars = {} })
                
            end
        end
        
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

    -- vouchers
    local spritesFiles = love.filesystem.getDirectoryItems(mod.path.."assets/1x/vouchers")
    
    for k, file in pairs(spritesFiles) do
        if string.find(file, ".png") then

            name = string.sub(file, 1, string.len(file) - 4)

            local sprite = SMODS.Sprite:new(
                tpvoucherSlug(name),
                mod.path,
                "vouchers/" .. file,
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







function Load_Config()
    local mod = SMODS.findModByID(TETRAPAKID)
    
 
    if not love.filesystem.getInfo(mod.path.."config.lua") then
        print("No config file found for Tetrapak, creating")
        local file = love.filesystem.newFile(mod.path.."config.lua")
        local allcardnames = {}
        for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."jokers")) do
            table.insert(allcardnames, string.sub(v, 1, string.len(v) - 4):lower())
        end

        for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."spectrals")) do
            table.insert(allcardnames, string.sub(v, 1, string.len(v) - 4):lower())
        end

        local conf = GetDefaultConfig()
        for k, v in pairs(allcardnames) do
            conf.Enabled[v] = true
        end

        Save_Config(conf)
    end

    local config = nil
    local success, configLoader = pcall(love.filesystem.load, mod.path.."config.lua")
    if success then
        local success, loadedconfig = pcall(configLoader)
        if not success then
            -- Handle error in config
            loadedconfig = GetDefaultConfig()
        end

        config = loadedconfig
    else
        -- Handle error in loading config
        config = GetDefaultConfig()
    end
    Save_Config(config)

    -- fill in Enabled with any new cards that have no entry
    local allcardnames = {}
    for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."jokers")) do
        table.insert(allcardnames, string.sub(v, 1, string.len(v) - 4):lower())
    end

    for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."spectrals")) do
        table.insert(allcardnames, string.sub(v, 1, string.len(v) - 4):lower())
    end

    for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."vouchers")) do
        table.insert(allcardnames, string.sub(v, 1, string.len(v) - 4):lower())
    end

    for k, v in pairs(allcardnames) do
        if config.Enabled[v] == nil then
            config.Enabled[v] = true
        end
    end
    Save_Config(config)

    G.TETRAPAK_Config = config
    
end


function Save_Config(conf)
    if not conf then
        conf = G.TETRAPAK_Config
    end
    local mod = SMODS.findModByID(TETRAPAKID)
    local file = love.filesystem.newFile(mod.path.."config.lua")
    file:open("w")
    file:write("return " .. table.tostring(conf))
    file:close()
end


function GetDefaultConfig()
   
        return {
            info = [[
                This is the config file for Tetrapak. 
                Set the value of each card to true to enable it, or false to disable it.
                If you want to disable a card, you can also just delete the file from the jokers or spectrals folder.

                there will be more options in the future.
            ]],
            Enabled = {

            }
        }
    
end


function table.tostring(tbl, depth)
    if not depth then
        depth = 1
    end
    local str = "{\n"
    local indents = str.rep("    ", depth)

    for k, v in pairs(tbl) do
        MAX_DEPTH = 2
        if depth > MAX_DEPTH then
            str = str .. indents .. k .. " = \"...\",\n"
            break
        end
        if type(v) == "table" then
            str = str .. indents .. k .. " = " .. table.tostring(v, depth + 1) .. ",\n"
        elseif type(v) == "string" then
            str = str .. indents .. k .. " = [[\n" .. v .. "]],\n"
        else
            str = str .. indents .. k .. " = " .. tostring(v) .. ",\n"
        end
    end
    
    str = str .. "}"
    return str
end