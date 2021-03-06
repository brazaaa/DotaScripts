local AntiBlur = {}

Menu.AddOptionIcon({"Awareness", "Anti-Blur PA"}, "panorama/images/heroes/icons/npc_dota_hero_phantom_assassin_png.vtex_c")
AntiBlur.optionEnable = Menu.AddOptionBool({ "Awareness", "Anti-Blur PA" }, "Activation", false)
AntiBlur.optionSize = Menu.AddOptionSlider({ "Awareness", "Anti-Blur PA" }, "Size", 800, 3000, 800)

local Phantom = {false, false, false}

function AntiBlur.GetPA(object, myHero)
	if not myHero then return end
	
	if not object[1] then
		for i = 1, 10 do
			local hero = Heroes.Get(i)
			if hero and not Entity.IsSameTeam( myHero, hero ) then
				local name = NPC.GetUnitName( hero )
				if (name == "npc_dota_hero_phantom_assassin") then
					object[1] = hero
					return
				end
			end
		end
	end
end

function AntiBlur.FindPA(object)
	if not object[1] then return end
	
	local visible = not Entity.IsDormant( object[1] )
	local hasBlur = NPC.HasModifier(object[1], "modifier_phantom_assassin_blur_active") or false
	
	if visible and hasBlur then
		local pos = Entity.GetAbsOrigin( object[1] )
		object[2] = pos
		object[3] = true
	else
		object[2] = false
		object[3] = false
	end
end

function AntiBlur.OnUpdate()
	AntiBlur.enabled = Menu.IsEnabled( AntiBlur.optionEnable )
	if not AntiBlur.enabled then return end
	
	if not Phantom[1] then
		AntiBlur.GetPA(Phantom, Heroes.GetLocal())
	end

	AntiBlur.Size = Menu.GetValue( AntiBlur.optionSize )
	
	AntiBlur.FindPA(Phantom)
end

function AntiBlur.OnDraw()
	if not AntiBlur.enabled then return end
	
	if Phantom[3] and Phantom[2] then
		MiniMap.DrawHeroIcon( "npc_dota_hero_phantom_assassin", Phantom[2], 255, 255, 255, 255, AntiBlur.Size )
	end
end

return AntiBlur
