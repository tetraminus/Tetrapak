WebGenerator = {}
local function toWebRarity(rarity )
    

    if rarity == 1 then
        return "Common"
    elseif rarity == 2 then
        return "Uncommon"
    elseif rarity == 3 then
        return "Rare"
    elseif rarity == 4 then
        return "Legendary"
    elseif rarity == CURSERARITY then
        return "Curse"
    end
    -- capitalise the first letter

    return string.upper(string.sub(rarity, 1, 1)) .. string.sub(rarity, 2)
    

end

local function getDefaultLocText(card)
    if not card.config or not card.config.center then
        local retval = card.loc_text
        if type(retval) == "table" then
            return retval
        end
        return card.loc_txt
    end
    print("card", table.tostring(card))
    local center = card.config.center

    if not center.config then
        local retval = center.loc_text
        if type(retval) == "table" then
            return retval
        end
        return center.loc_txt
    end



    local card = {
        
        config = center.config
    }   
    card.config.center = center
    card.ability = center.config
    print("card", table.tostring(card))

    --card.config.center = center

    local vars = {}
    if center.loc_def then
        vars = center.loc_def(card)
    end

    

    local loc_txt = center.loc_text
    if type(loc_txt) ~= "table" then
        loc_txt = center.loc_txt
    end

    for k, v in pairs(vars) do
        for k2, v2 in pairs(loc_txt.text) do
            loc_txt.text[k2] = string.gsub(v2, "#" .. k .. "#", v)
        end
    end
   
    return loc_txt
end

local function CreateWebEntry(center, type)
    local entry = {}
    entry.name = center.name
    entry.loc_txt = center.loc_txt
    entry.rarity = toWebRarity(center.rarity or type)

    -- output in format 
    --   {
--      name: "Joker",
--     text: [
--       "{C:mult}+4{} Mult"
--     ],
--     image_url: "img/j_joker.png",
--     rarity: "Common"
--   }



    local FinalEntry = ""
    FinalEntry = FinalEntry .. "{\n"
    FinalEntry = FinalEntry .. "name: \"" .. getDefaultLocText(center).name .. "\",\n"
    FinalEntry = FinalEntry .. "text: [\n"
    for k, v in pairs(getDefaultLocText(center).text) do
        FinalEntry = FinalEntry .. "\"" .. v .. "\",\n"
    end
    
    
    FinalEntry = FinalEntry .. "],\n" 
    
    local imgname = center.key
    --remove everything before the generated id, as the image is
    local toremove = tpmakeID("") -- remove the generated id and all before it
    imgname = string.sub(imgname, string.find(imgname, toremove) + string.len(toremove))
    
    
    local assetpath = "assets/1x/"..type.."s/" .. imgname .. ".png"
    FinalEntry = FinalEntry .. "image_url: \"" .. assetpath .. "\",\n"


    if entry.rarity then
        FinalEntry = FinalEntry .. "rarity: \"" .. entry.rarity .. "\"\n"
    else
        -- use the type instead
        FinalEntry = FinalEntry .. "rarity: \"" .. type .. "\"\n"
    end

    FinalEntry = FinalEntry .. "},\n"
    return FinalEntry

    
end






function WebGenerator:generateWeb()
    local entries = {}
    local output = "let data = {\n"
    for k, defs in pairs(Tetrapak.Registry) do
        entries[k] = {}
        for k2, def in pairs(defs) do
            local type = k:lower()
            --remove the s from the end
            type = string.sub(type, 1, string.len(type) - 1)
            table.insert(entries[k], CreateWebEntry(def, type))
            
        end

        output = output .. "  " .. k:lower() .. ": [\n"
        for k, v in pairs(entries[k]) do
            output = output .. v
        end

        output = output .. "  ],\n"

        
    end

    output = output .. "}\n"


    


    

    
    
    local mod = SMODS.current_mod
    local modpath = mod.path

    -- create the web folder
    if not love.filesystem.getInfo(modpath .. "web") then
        love.filesystem.createDirectory(modpath .. "web")
    end

    -- write to file
    local file = love.filesystem.newFile(modpath .. "web/data.js")
    file:open("w")
    file:write(output)
    file:close()



    
end


