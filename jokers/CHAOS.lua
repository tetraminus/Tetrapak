

local function init()
    local loc_text = {
        name = "Chaos Joker",
        text = {
            "Everything can be anything!"
        }
    }

    local chaosjoker = SMODS.Joker:new(
        "Chaos Joker",
        tpmakeID("chaos_joker"),
        {
            
        },
        {
            x = 0,
            y = 0
        },
        loc_text,
        3, -- rarity
        7, -- cost
        true,
        true,
        true,
        true,
        "Chaos Joker"
    )
    
    -- im gonna leave this here for now, but i think this should never be unleashed

    --Tetrapak.Jokers["j_" .. tpmakeID("chaos_joker")] = chaosjoker
    
end

local function load_effect()

    local get_pool_ref = get_current_pool
        function get_current_pool(_type, _rarity, _legendary, _append)

            if next(find_joker("Chaos Joker"))  then
                local all = {}
                for k, v in pairs(G.P_CENTERS) do
                    table.insert(all, k)
                end
                return all, "j_" .. tpmakeID("chaos_joker")
            end

            local pool, poolkey = get_pool_ref(_type, _rarity, _legendary, _append)
            -- remove from pool if not seeded
            
            
            return pool, poolkey
        end


    local  can_skip_ref =  G.FUNCS.can_skip_booster 

    function G.FUNCS.can_skip_booster(e)
        if next(find_joker("Chaos Joker")) then
            return true
        end
        return can_skip_ref(e)
    end
 

    

    
    
end

return {
    init = init,
    load_effect = load_effect
    
}