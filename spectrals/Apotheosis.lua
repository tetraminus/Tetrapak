

local function init()
    local mod = SMODS.findModByID(TETRAPAKID)

    local aposoul = SMODS.Sprite:new(
        tpconsumableSlug("ApoSoul"),
        mod.path,
        "extra/ApoSoul.png",
        86,
        79,
        "asset_atli"
    )

    aposoul:register()


    local loc_text = {
        name = "Apotheosis",
        text = {
            "{C:inactive}RISE BEYOND THE LIMITS OF MORTALITY.{}",
            "{C:inactive}UNWIND THE VERY THREADS OF FATE ITSELF.{}",
            "{C:attention}Remove the seed of the run{}"
        }
    }

    local data ={
        name = "Apotheosis",
        slug = tpmakeID("apotheosis"),
        config = {
            extra = {
                
            }
        },
        pos = {
            x = 0,
            y = 0
        },
        
        loc_text = loc_text,
        cost = 6,
        discovered = true

    }

    local Apotheosis = SMODS.Spectral:new(data.name, data.slug, data.config, data.pos, data.loc_text, data.cost, true, data.discovered)
    

    Tetrapak.Spectrals[tpmakeID("apotheosis")] = Apotheosis
    
    
end

local function load_effect()

        local get_pool_ref = get_current_pool
        function get_current_pool(_type, _rarity, _legendary, _append)
            local pool, poolkey = get_pool_ref(_type, _rarity, _legendary, _append)
            -- remove from pool if not seeded
            if not G.GAME.seeded then
                for i = #pool, 1, -1 do
                    if pool[i] == tpconsumableSlug("apotheosis") then
                        table.remove(pool, i)
                        print("removed apotheosis from pool")
                    end
                end
                
            end
            
            return pool, poolkey
        end


        SMODS.Spectrals[tpconsumableSlug("apotheosis")].soul_pos = {
            x = 0,
            y = 0
        }
        
        local Card_align_ref = Card.align
        function Card:align()  
            Card_align_ref(self)
            if self.children.floating_sprite and self.config.center.name == "Apotheosis" then
                self.children.floating_sprite.x = 0
                self.children.floating_sprite.y =0
            end
        end

        --function Card:set_sprites(_center, _front)
        local set_sprites_ref = Card.set_sprites
        function Card:set_sprites(_center, _front)
            set_sprites_ref(self, _center, _front)
            print(self.config.center.name)
            if self.config.center.name == "Apotheosis" then
                
                self.children.floating_sprite = Sprite(self.T.x-26, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS[tpconsumableSlug("ApoSoul")], self.config.center.soul_pos)
            end
        end
    
        SMODS.Spectrals[tpconsumableSlug("apotheosis")].use = function(card, area, copier)
            G.GAME.pseudorandom.seed = tostring(math.random(1, 999999))
            G.GAME.seeded = false
        end

        SMODS.Spectrals[tpconsumableSlug("apotheosis")].can_use = function(card)
            return true
        end


end

return {
    init = init,
    load_effect = load_effect
}