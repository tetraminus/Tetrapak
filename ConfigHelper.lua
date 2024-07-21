



function Load_Config()
    local mod = SMODS.current_mod
    
 
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

    for k, v in pairs(love.filesystem.getDirectoryItems(mod.path.."blinds")) do
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
    local mod = SMODS.current_mod
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