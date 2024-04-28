

local function init()
    local mirroredjoker = SMODS.Joker:new(
        "Mirrored Joker",
        "mirrored_joker",
        {
            extra = {}
        },
        {
            x = 0,
            y = 0
        },
        {
            name = "Mirrored Joker",
            text = {
                "Swaps the {C:chips}chips{} and",
                "{C:red}mult{} of your hand."
            }
        },
        3,
        7,
        true,
        true,
        false,
        true,
        "Mirrored Joker"
    )
    
    Tetrapak.Jokers.j_mirrored_joker = mirroredjoker
    print("Mirrored Joker initialized")
    
end

local function load_effect()

    function SMODS.Jokers.j_mirrored_joker.calculate(card, context)
        if context.cardarea == G.jokers and SMODS.end_calculate_context(context) then
            local currChips =  hand_chips
            local currMult = mult

            hand_chips = currMult
            mult = currChips
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})

            return {
              
                message = "Swapped!",
    
            }
        end
    end
    
end

return {
    init = init,
    load_effect = load_effect
    
}