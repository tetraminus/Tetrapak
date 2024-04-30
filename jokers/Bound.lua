


local function init()
    local Bound = SMODS.Joker:new(
        "Bound",
        tpmakeID("bound"),
        {
        },
        {
            x = 0,
            y = 0
        },
        {
            name = "Bound",
            text = {
                "Does not give +1 joker slot",
            }
        },
        CURSERARITY,
        0,
        true,
        true,
        false,
        true,
        "Bound"
        
    )
    
    Tetrapak.Jokers["j_" .. tpmakeID("bound")] = Bound
    
    
end

local function load_effect()
    
end

return {
    init = init,
    load_effect = load_effect
}