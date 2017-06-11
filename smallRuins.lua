--[[
   This is a table of functions, that when called with an area and center position, will spawn different ruins.
   If you want to add more ruins, simply observe the format, and create it accordingly.
   Remember that the server must also share this config, exactly, to prevent desyncs.
   Format:

   function(center)
   --code to spawn entities relative to the center
   end,

--]]

local fN = game.forces.neutral
local direct = defines.direction

--checks for spawning validity and if valid, clears space for the spawn
function s_clearArea(center)
   for y = center.y-4, center.y+4 do --fail if any water in area
      for x = center.x-4, center.x+4 do
         if game.surfaces[1].get_tile(x, y).name == "water" or game.surfaces[1].get_tile(x, y).name == "deepwater" then
            return false
         end
      end
   end

   for index, entity in pairs(game.surfaces[1].find_entities({{center.x-4,center.y-4},{center.x+4,center.y+4}})) do
      if not string.find(entity.name, "-ore") then --don't destroy ores
         entity.destroy()
      end
   end

   return true
end

local s_ruins = {
   function(center) --land mine bunker

      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-wall", position = {center.x-2,center.y}, force = fN}
      ce{name = "stone-wall", position = {center.x-2,center.y-1}, force = fN}
      ce{name = "stone-wall", position = {center.x-2,center.y-2}, force = fN}
      ce{name = "stone-wall", position = {center.x+1,center.y-1}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y-2}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y-1}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y+1}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y+2}, force = fN}
      ce{name = "stone-wall", position = {center.x+2,center.y+3}, force = fN}
      ce{name = "stone-wall", position = {center.x+1,center.y+3}, force = fN}
      ce{name = "stone-wall", position = {center.x, center.y+3}, force = fN}

      ce{name = "land-mine", position = {center.x, center.y}, force = game.forces.enemy} --trap

   end,
   function(center)  --small smelting station
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-furnace", position = {center.x-2,center.y-2}, force = fN}
      local chest = ce{name = "wooden-chest", position = {center.x, center.y-1}, force = fN}
      chest.insert{name = "coal", count=5}
      chest.insert{name = "iron-ore", count=20}
   end,
   function(center) --small destroyed setup
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "assembling-machine-1", position = {center.x+0.5,center.y+2.5}, force = fN}.damage(150,"neutral","physical")
      ce{name = "inserter", position = {center.x+2.5,center.y+1.5}, force = fN}.damage(25,"neutral","physical")
      ce{name = "inserter", position = {center.x+0.5,center.y-1.5}, force = fN}.damage(17,"neutral","physical")

      ce{name = "transport-belt", position = {center.x-1.5,center.y+1}, force = fN}.damage(25,"neutral","physical")
      ce{name = "transport-belt", position = {center.x-1.5,center.y}, force = fN}
      ce{name = "transport-belt", position = {center.x-1.5,center.y-1}, force = fN}.damage(15,"neutral","physical")
   end,
   function(center) --random walls
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-wall", position = {center.x-2.5,center.y-2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+0.5,center.y-2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x-1.5,center.y-1.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+2.5,center.y+1.5}, force = fN}
      ce{name = "stone-wall", position = {center.x-1.5,center.y-0.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+2.5,center.y-0.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+1.5,center.y+0.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+1.5,center.y+1.5}, force = fN}
      ce{name = "stone-wall", position = {center.x-0.5,center.y+2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+2.5,center.y+2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x-2.5,center.y+3.5}, force = fN}
      ce{name = "stone-wall", position = {center.x-1.5,center.y+3.5}, force = fN}
   end,
   function(center) --harmless turret
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "gun-turret", position = {center.x+1,center.y}, force = game.forces.enemy}.damage(323,"neutral","physical")
   end,
   function(center) --suspicious rock, stash
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      local chest = ce{name = "wooden-chest", position = {center.x, center.y}, force = fN}
      chest.insert{name = "engine-unit", count=8}
      chest.insert{name = "iron-plate", count=20}
      chest.insert{name = "steel-plate", count=5}
      ce{name = "stone-rock", position = {center.x, center.y}, force = fN}
   end,
   function(center) --randomly damaged diagonal wall
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-wall", position = {center.x-2.5,center.y+3.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x-2.5,center.y+2.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x-1.5,center.y+2.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x-1.5,center.y+1.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x-0.5,center.y+1.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x-0.5,center.y+0.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x, center.y}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+0.5,center.y-0.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+1.5,center.y-0.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+1.5,center.y-1.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+2.5,center.y-1.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+2.5,center.y-2.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
      ce{name = "stone-wall", position = {center.x+3.5,center.y-2.5}, force = fN}.damage(math.random(0,400),"neutral","physical")
   end,

   function(center) --section of wall with gate
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-wall", position = {center.x+0.5,center.y-2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+0.5,center.y-1.5}, force = fN}

      ce{name = "gate", position = {center.x+0.5,center.y-0.5}, force = fN}
      ce{name = "gate", position = {center.x+0.5,center.y+0.5}, force = fN}
      ce{name = "gate", position = {center.x+0.5,center.y+1.5}, force = fN}

      ce{name = "stone-wall", position = {center.x+0.5,center.y+2.5}, force = fN}
      ce{name = "stone-wall", position = {center.x+0.5,center.y+3.5}, force = fN}
   end,
   function(center) --small mountain
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "stone-rock", position = {center.x-1,center.y-1}, force = fN}
      ce{name = "stone-rock", position = {center.x+1,center.y-1}, force = fN}
      ce{name = "stone-rock", position = {center.x-1,center.y+1}, force = fN}
      ce{name = "stone-rock", position = {center.x+1,center.y+1}, force = fN}
   end,
   function(center) --research station
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "lab", position = {center.x+1.5,center.y-0.5}, force = fN}
      ce{name = "wooden-chest", position = {center.x-1.5,center.y+0.5}, force = fN}.insert{name = "science-pack-1", count=20}
   end,
   function(center) --mining setup
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "electric-mining-drill", position = {center.x+(0.0),center.y+(0.0)}, direction = direct.south, force = fN}
      ce{name = "wooden-chest", position = {center.x+(0.0),center.y+(2.0)}, force = fN}
   end,
   function(center) -- cross of pipes
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "pipe-to-ground", position = {center.x+(-2.0),center.y+(0.0)}, direction = direct.east, force = fN}
      ce{name = "pipe", position = {center.x+(-1.0),center.y+(0.0)}, force = fN}
      ce{name = "pipe", position = {center.x+(1.0),center.y+(0.0)}, force = fN}
      ce{name = "pipe-to-ground", position = {center.x+(0.0),center.y+(-1.0)}, direction = direct.south, force = fN}
      ce{name = "pipe", position = {center.x+(0.0),center.y+(0.0)}, force = fN}
      ce{name = "pipe-to-ground", position = {center.x+(2.0),center.y+(0.0)}, direction = direct.west, force = fN}
      ce{name = "pipe-to-ground", position = {center.x+(0.0),center.y+(1.0)}, force = fN}
   end,
   function(center) --section of rails
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "straight-rail", position = {center.x+(-2.0),center.y+(0.0)}, direction = direct.east, force = fN}
      ce{name = "straight-rail", position = {center.x+(0.0),center.y+(0.0)}, direction = direct.east, force = fN}
      ce{name = "straight-rail", position = {center.x+(2.0),center.y+(0.0)}, direction = direct.east, force = fN}
   end,
   function(center) --victory poles
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end
      ce{name = "small-electric-pole", position = {center.x+(0.0),center.y+(-2.0)}, force = fN}
      ce{name = "small-electric-pole", position = {center.x+(-2.0),center.y+(0.0)}, force = fN}
      ce{name = "medium-electric-pole", position = {center.x+(0.0),center.y+(-1.0)}, force = fN}
      ce{name = "small-electric-pole", position = {center.x+(2.0),center.y+(0.0)}, force = fN}
      ce{name = "small-electric-pole", position = {center.x+(0.0),center.y+(1.0)}, force = fN}
   end,
   function(center) --I of splitters
      local ce = game.surfaces[1].create_entity --save typing
      if s_clearArea(center) == false then return end

      ce{name = "splitter", position = {center.x+(-0.5),center.y+(-2.0)}, direction = direct.south, force = fN}
      ce{name = "splitter", position = {center.x+(1.5),center.y+(-2.0)}, direction = direct.south, force = fN}
      ce{name = "splitter", position = {center.x+(-0.5),center.y+(0.0)}, direction = direct.south, force = fN}
      ce{name = "splitter", position = {center.x+(1.5),center.y+(0.0)}, direction = direct.south, force = fN}
      ce{name = "splitter", position = {center.x+(0.5),center.y+(-1.0)}, direction = direct.south, force = fN}
      ce{name = "splitter", position = {center.x+(0.5),center.y+(1.0)}, direction = direct.south, force = fN}
   end,
}

function spawnSmallRuins(center)
   s_ruins[math.random(#s_ruins)](center) --call a random function
   game.surfaces[1].set_tiles({{name = "concrete", position = center}})
end
