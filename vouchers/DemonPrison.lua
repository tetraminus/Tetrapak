local function init()
    local loc_text = {
        name = "Demon Prison",
        text = {
            "You may disable curses."
        }
    }

    local data = {
        name = "DemonPrison",
        key = "demonprison",
        loc_txt = loc_text,
    }

    local DemonPrison = SMODS.Voucher(data)

    Tetrapak.Vouchers[tpvoucherSlug("demonprison")] = DemonPrison
    
    
end

local function load_effect()


    


end

return {
    init = init,
    load_effect = load_effect,
    after = "EmptyCage",
}