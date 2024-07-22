--- STEAMODDED HEADER
--- MOD_NAME: Tetrapak
--- MOD_ID: tetraminus_tetrapak
--- PREFIX: tetrapak
--- MOD_AUTHOR: [tetraminus]
--- MOD_DESCRIPTION: A Content pack for Balatro.
--- DISPLAY_NAME: Tetrapak
--- BADGE_COLOUR: 3333aa

----------------------------------------------
------------MOD CODE -------------------------


TETRAPAKID = "tetraminus_tetrapak"

tpmakeID = function(id)
    --to lazy to refactor all the old code
    return id
end

tpjokerSlug = function(id)
    return "j_tetrapak_" .. tpmakeID(id)
end

tpconsumableSlug = function(id)
    return "c_tetrapak_" .. tpmakeID(id)
end

tpvoucherSlug = function(id)
    return "v_tetrapak_" .. tpmakeID(id)
end

tpblindSlug = function(id)
    return "bl_tetrapak_" .. tpmakeID(id)
end



CURSERARITY = "tetrapak_Curses"


Tetrapak = {}

GENPAGE = true

function table.tostring(tbl, depth)
    local MAX_DEPTH = 3
    if not depth then
        depth = 1
    end
    
    local indents = string.rep("    ", depth)
    local str =  "{\n"

    for k, v in pairs(tbl) do
        
        if depth > MAX_DEPTH then
            str = str .. indents .. k .. " = \"...\",\n"
            break
        end
        if type(v) == "table" then
            str = str .. indents .. k .. " = " .. table.tostring(v, depth + 1) .. ",\n"
        elseif type(v) == "string" then
            str = str .. indents .. k .. " = [[" .. v .. "]],\n"
        else
            str = str .. indents .. k .. " = " .. tostring(v) .. ",\n"
        end
    end
    
    str = str .. indents .. "}"
    return str
end


local function initRegisterAndLoad(alldefs)
    

    for k, defs in pairs(alldefs) do
        for k, def in pairs(defs) do
            if def.init then
                def.init()
            end
        end
    end

    Tetrapak.Registry = {
        Jokers = Tetrapak.Jokers,
        Spectrals = Tetrapak.Spectrals,
        Vouchers = Tetrapak.Vouchers,
        Blinds = Tetrapak.Blinds
    }

    

    for k, defs in pairs(alldefs) do
        for k, def in pairs(defs) do
            if def.load_effect then
                def.load_effect()
            end
        end
    end
    
end

local function loadSprites(directory, folder, slugFunction, sprites)
    
    local mod = SMODS.current_mod
    local spritesFiles = NFS.getDirectoryItems(directory)


    

    for k, file in pairs(spritesFiles) do
        if string.find(file, ".png") then
            name = string.sub(file, 1, string.len(file) - 4)
            print("loading sprite: " .. name)
            local sprite = SMODS.Atlas(
                {
                    key = (name),
                    path = folder .. "/" .. file,
                    px=71,
                    py=95,
                    
                }
            )

            G.ASSET_ATLAS[name] = {}

            table.insert(sprites, sprite)
            
        end
          
    end
end

local function Load_atlas()

    local mod = SMODS.current_mod
    local sprites = {}
    

    
    -- jokers
    loadSprites(mod.path.."assets/1x/jokers", "jokers", tpjokerSlug, sprites)

    -- spectrals
    loadSprites(mod.path.."assets/1x/spectrals", "spectrals", tpconsumableSlug, sprites)

    -- vouchers
    loadSprites(mod.path.."assets/1x/vouchers", "vouchers", tpvoucherSlug, sprites)


    -- blinds
    local spritesFiles = NFS.getDirectoryItems(mod.path.."assets/1x/blinds")

    for k, file in pairs(spritesFiles) do
        if string.find(file, ".png") then

            name = string.sub(file, 1, string.len(file) - 4)

            local sprite = SMODS.Atlas(--{
               
                {
                key = name,
                path = "blinds/" .. file,
                px=34,
                py=34,
                
            }
            )

            table.insert(sprites, sprite)
            print("Loaded sprite: " .. file)

        end
    end
    
    print(table.tostring(G.ASSET_ATLAS))
    for k, v in pairs(Tetrapak.Registry) do
        
        for k, v in pairs(v) do
            print("loading atlas: " .. v.atlas)
            local atlasname = v.key
            -- remove the prefix by the _
            atlasname = string.sub(atlasname, string.find(atlasname, "_") + 1)
            

            if v.atlas == "Temp" then
                atlasname = "Jokers"
            end

            v.atlas = atlasname
            print(v.atlas)

        end
    end

    for k, sprite in pairs(sprites) do
        --sprite:register()
    end
end



    local mod = SMODS.current_mod
    local modpath = mod.path

    -- load stuff
    

    NFS.load(modpath.."ConfigHelper.lua")()
    NFS.load(modpath.."WebGenerator.lua")()



    Load_Config()
    
    
    

    G.P_JOKER_RARITY_POOLS[CURSERARITY] = {}
    
    G.C.RARITY[CURSERARITY] = HEX("444444")

    
    SMODS.current_mod.process_loc_text = function()
        G.localization.misc.dictionary["k_"..CURSERARITY] = "Curse"
        G.localization.descriptions.Other["k_curse_tip"] = {
            name = "Curse",
            text = {
                "This card is cursed.",
                "It cannot be sold.",
                "+1 Joker slot"
            }
        }
    end

    local loc_colour_ref = loc_colour
    function loc_colour(key)
        if key == CURSERARITY then return HEX("444444")
        else return loc_colour_ref(key) end
    end


    local get_badge_colourref = get_badge_colour
	function get_badge_colour(key)
		local fromRef = get_badge_colourref(key)
	
		if key == CURSERARITY then return HEX("444444") 
		else return fromRef end
	end
    Tetrapak.Registry = {}

    Tetrapak.Jokers = {}
    Tetrapak.Spectrals = {}
    Tetrapak.Vouchers = {}
    Tetrapak.Blinds = {}

    local alldefs = {}

    --load all files in the jokers folder
    
    local jokerFiles = NFS.getDirectoryItems(mod.path.."jokers")
    
    local jokerdefs = {}
    for k, file in pairs(jokerFiles) do
        lowercasename = string.sub(file, 1, string.len(file) - 4):lower()
        print("checking " .. lowercasename)
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[lowercasename] then
            print("loading joker: " .. file)
            local joker = NFS.load(mod.path.."jokers\\"..file)()
            
            table.insert(jokerdefs, joker)

        end
    end
    print(table.tostring(jokerdefs))
    table.insert(alldefs, jokerdefs)

    -- load all files in the spectrals folder
    local spectralFiles = NFS.getDirectoryItems(mod.path.."spectrals")
    local spectraldefs = {}
    for k, file in pairs(spectralFiles) do
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[string.sub(file, 1, string.len(file) - 4):lower()] then
            local spectral = NFS.load(mod.path.."spectrals/"..file)()
            table.insert(spectraldefs, spectral)
        end
    end
    
    table.insert(alldefs, spectraldefs)
    -- load all files in the vouchers folder
    local voucherFiles = NFS.getDirectoryItems(mod.path.."vouchers")
    local voucherdefs = {}
    for k, file in pairs(voucherFiles) do
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[string.sub(file, 1, string.len(file) - 4):lower()] then
            local voucher = NFS.load(mod.path.."vouchers/"..file)()
            table.insert(voucherdefs, voucher)
        end
    end

    table.insert(alldefs, voucherdefs)

    -- place voucherdefs in the correct order by the after field, ex: after = "emptycage"
    local function sort_voucherdefs(a, b)
        if a.after == b.name then
            print("aligned")
            return true
        end
        return false
    end

    table.sort(voucherdefs, sort_voucherdefs)

    -- load all files in the blinds folder
    local blindFiles = NFS.getDirectoryItems(mod.path.."blinds")
    local blinddefs = {}
    for k, file in pairs(blindFiles) do
        if string.find(file, ".lua") and G.TETRAPAK_Config.Enabled[string.sub(file, 1, string.len(file) - 4):lower()] then
            local blind = NFS.load(mod.path.."blinds/"..file)()
            table.insert(blinddefs, blind)
        end
    end

    table.insert(alldefs, blinddefs)
    



    --- DISABLE DEBUG MODE AFTER TESTING
    --G.DEBUG = true
    _RELEASE_MODE = false

    

    initRegisterAndLoad(alldefs)
    Load_atlas()
    
    

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
    for k, v in pairs(SMODS.Centers) do
        if v.rarity == CURSERARITY then
            local old_tooltip = v.tooltip
            v.tooltip = function (_c, info_queue)
                if old_tooltip then
                    old_tooltip(_c, info_queue)
                end
                info_queue[#info_queue + 1] = { set = 'Other', key = 'k_curse_tip'}
                
            end
        end
        
    end



    if GENPAGE then
        WebGenerator:generateWeb()
    end 








function table.addall(t1, t2)
    for k, v in pairs(t2) do
        table.insert(t1, tostring(k))
    end
    
end

