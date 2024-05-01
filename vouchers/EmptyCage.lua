local function init()

    local data ={
        name = "EmptyCage",
        slug = tpmakeID("emptycage"),
        config = {
            extra = {
                
            }
        },
        pos = {
            x = 0,
            y = 0
        },
        loc_text = {
            name = "Empty Cage",
            text = {
                "You may disable jokers."
            }
        
        },
        cost = 6,
        discovered = true

    }

    local EmptyCage = SMODS.Voucher:new(data.name, data.slug, data.config, data.pos, data.loc_text, data.cost, true, data.discovered)


    Tetrapak.Vouchers[tpvoucherSlug("emptycage")] = EmptyCage
    
    
end

local function load_effect()

    function Card:toggle_debuff()
        G.jokers:unhighlight_all()
        if self.debuff then
            self:set_debuff(false)
            self.caged = false
        else
            self:set_debuff(true)
            self.caged = true
        end
    end

    function Card:can_toggle_debuff()
        local allowcurse = false
        if G.GAME.used_vouchers[tpvoucherSlug("demonprison")] then
   
            allowcurse = true
        end
      
        if (self.config.center.rarity == CURSERARITY) and not allowcurse then
   
            return false
        end

        if self.debuff and not self.caged then
            return false
        end

        return true
    end

        
    G.FUNCS.toggle_debuff = function(e)
        local card = e.config.ref_table
        card:toggle_debuff()
    end

    G.FUNCS.can_toggle_debuff = function(e)
    if e.config.ref_table:can_toggle_debuff() then 
        e.config.colour = G.C.RED
        e.config.button = 'toggle_debuff'
    else
      	e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      	e.config.button = nil
    end
  end


    --G.GAME.used_vouchers
    local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local retval = use_and_sell_buttonsref(card)
        
        if card.area and card.area.config.type == 'joker' and card.ability.set == 'Joker' and G.GAME.used_vouchers[tpvoucherSlug("emptycage")] then
            local fuse = 
            {n=G.UIT.C, config={align = "cr"}, nodes={
            
            {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.GOLD, one_press = true, button = 'toggle_debuff', func = 'can_toggle_debuff'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = "Disable",colour = G.C.UI.TEXT_LIGHT, scale = 1, shadow = true}}
                    }},
                    
                }}
            }}
            }}
            retval.nodes[1].nodes[2].nodes = retval.nodes[1].nodes[2].nodes or {}
            table.insert(retval.nodes[1].nodes[2].nodes, fuse)
            return retval
        end

        return retval
    end

    


end

return {
    init = init,
    load_effect = load_effect,
    name = "EmptyCage",
}