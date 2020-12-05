-- Made by Kanade
local SCOREBOARD = {}
SCOREBOARD.AdminUsergroup = "superadmin"

if not Frame then
	Frame = nil
end

surface.CreateFont("sb_names", {font = "monofonto", size = 22, weight = 333, outline = true, antialias = false, scanlines = 2,})


function RanksEnabled()
	return GetConVar("br_scoreboardranks"):GetBool()
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function role_GetPlayers(role)
	local all = {}
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			if not v.GetNClass then
				player_manager.RunClass( v, "SetupDataTables" )
			end

			if v.GetNClass then
				if v:GetNClass() == role then
					table.ForceInsert(all, v)
				end
			end
		end
	end
	return all
end

function ShowScoreBoard()

	local ply = LocalPlayer()
	local allplayers = {}
	table.Add(allplayers, player.GetAll())

	local mtfs = {}
	table.Add(mtfs, role_GetPlayers(ROLE_MTFGUARD))
	table.Add(mtfs, role_GetPlayers(ROLE_MTFCOM))
	table.Add(mtfs, role_GetPlayers(ROLE_MTFNTF))

	local playerlist = {}

	table.ForceInsert(playerlist, {
		name = "SCPs",
		list = team.GetPlayers( TEAM_SCP ),
		color = team.GetColor( TEAM_SCP ),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Mobile Task Force",
		list = mtfs,
		color = team.GetColor( TEAM_GUARD ),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Chaos Insurgency",
		list = role_GetPlayers(ROLE_CHAOS),
		color = Color(29, 81, 56),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Class D Personnel",
		list = role_GetPlayers(ROLE_CLASSD),
		--color = team.GetColor( TEAM_CLASSD ),
		color = Color(128,128,128),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Scientists",
		list = role_GetPlayers(ROLE_RES),
		--color = team.GetColor( TEAM_SCI ),
		color = Color(128,128,128),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Spectators",
		list = team.GetPlayers( TEAM_SPEC ),
		color = color_white,
		color2 = color_white
	})

	// Sort all
	table.sort( playerlist[1].list, function( a, b ) return a:Frags() > b:Frags() end )
	table.sort( playerlist[3].list, function( a, b ) return a:Frags() > b:Frags() end )
	table.sort( playerlist[4].list, function( a, b ) return a:Frags() > b:Frags() end )

	frameBg = vgui.Create("DFrame")
	frameBg:SetSize( ScrW(), ScrH() )
	frameBg:SetPos( 0, 0 )
	frameBg:SetTitle( "" )
	frameBg:SetVisible( true )
	frameBg:SetDraggable( false )
	frameBg:SetDeleteOnClose( true )
	frameBg:ShowCloseButton( false )
	frameBg:MakePopup()
	frameBg.Paint = function(self, w, h) 
		Derma_DrawBackgroundBlur(self, 0)
	end
	
	local breen_img = vgui.Create( "DImage", frameBg)	-- Add image to Frame
	breen_img:SetPos( ScrW()/2 - (ScrW()/6)/2, -500)
	--breen_img:SetPos( ScrW()/2 - (ScrW()/6)/2, 25)	-- Move it into frame
	breen_img:SetSize( ScrW()/6, ScrH()/4 )	-- Size it to 150x150
	-- Set material relative to "garrysmod/materials/"
	breen_img:SetImage( "materials/breach/scorebanner.png" )
	breen_img:MoveTo( ScrW()/2 - (ScrW()/6)/2, 25, 0.2, 0, -1)
	
	local color_main = 45

	local Frame = vgui.Create( "DFrame", frameBg)
	Frame:Center()
	Frame:SetSize(ScrW(), ScrH() )
	Frame:SetTitle( "" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:SetDeleteOnClose( true )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( false )
	Frame:Center()
	Frame:MakePopup()
	Frame.Paint = function( self, w, h )
		//draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 240 ) )
	end

	local width = 25
	
	local mainpanel = vgui.Create( "DPanel", Frame )
	mainpanel:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	mainpanel:SetPos(Frame:CenterHorizontal(0.5), Frame:CenterVertical(0.75))
	mainpanel:MoveTo( Frame:GetWide()/2 - mainpanel:GetWide()/2, Frame:CenterVertical(0.75), 0.2, 0, -1)
	mainpanel.Paint = function( self, w, h )
		//draw.RoundedBox( 0, 0, 0, w, h, Color( color_main, color_main, color_main, 240 ) )
	end

	local panel_backg = vgui.Create( "DPanel", mainpanel )
	panel_backg:Dock( FILL )
	panel_backg:DockMargin( 8, 50, 8, 150 )
	panel_backg.Paint = function( self, w, h )
		
		//draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 150) )
	end

	local DScrollPanel = vgui.Create( "DScrollPanel", panel_backg )
	DScrollPanel:Dock( FILL )
	
	local vbar = DScrollPanel:GetVBar()
	function vbar:Paint(w, h) return end
	function vbar.btnUp:Paint(w, h) return end
	function vbar.btnDown:Paint(w, h) return end
	function vbar.btnGrip:Paint(w, h)
		draw.RoundedBox( 0, 0, 15, w, h, Color( 48, 48, 48 ) )
		draw.RoundedBox( 0, 2, 17, w-4, h-19, Color(58, 58, 58))
	end


	local color_dark = Color( 35, 35, 35, 180 )
	local color_light = Color(80,80,80,180)

	local panelname_backg = vgui.Create( "DPanel", DScrollPanel )
	panelname_backg:Dock( TOP )
	//if i != 1 then
	//	panelname_backg:DockMargin( 0, 15, 0, 0 )
	//end
	panelname_backg:SetSize(0,width)
	panelname_backg.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(58, 58, 58) )
	end

	local panelwidth = 75

	local sbpanels = {
		{
			name = "Ping",
			size = panelwidth
		},
		{
			name = "Deaths",
			size = panelwidth
		},
		{
			name = "Kills",
			size = panelwidth
		}
	}
	--[[if KarmaEnabled() then
		table.ForceInsert(sbpanels, {
			name = "Karma",
			size = panelwidth
		})
	end]]
	if RanksEnabled() then
		table.ForceInsert(sbpanels, {
			name = "Group",
			size = panelwidth
		})
	end


	local MuteButtonFix = vgui.Create( "DPanel", panelname_backg )
	MuteButtonFix:Dock(RIGHT)
	MuteButtonFix:SetSize( width - 2, width - 2 )
	MuteButtonFix.Paint = function() end
	for i,pnl in ipairs(sbpanels) do
		local ping_panel = vgui.Create( "DLabel", panelname_backg )
		ping_panel:Dock( RIGHT )
		if i == 1 then
			ping_panel:DockMargin( 0, 0, 25, 0 )
		end
		ping_panel:SetSize(pnl.size, 0)
		ping_panel:SetText(pnl.name)
		ping_panel:SetFont("sb_names")
		ping_panel:SetContentAlignment(5)
		ping_panel:SetTextColor(Color(255,255,255,255))
		ping_panel.Paint = function( self, w, h )end
		drawb = !drawb
	end

	local i = 0
	for key,tab in pairs(playerlist) do
		i = i + 1
		if #tab.list > 0 then

			// players
			local panelwidth = 75
			local dark = true
			for k,v in pairs(tab.list) do
				local panels = {
					{
						name = "Ping",
						text = v:Ping(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Deaths",
						text = v:Deaths(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Frags",
						text = v:Frags(),
						color = color_white,
						size = panelwidth
					},
				}
				--[[if KarmaEnabled() then
					local tkarma = v:GetKarma()
					if tkarma == nil then tkarma = 999 end
					table.ForceInsert(panels, {
						name = "Karma",
						text = v:GetKarma(),
						color = color_white,
						size = panelwidth
					})
				end]]
				local rank = v:GetUserGroup()
				rank = firstToUpper(rank)
				if RanksEnabled() then
					table.ForceInsert(panels, {
						name = "Group",
						text = rank,
						color = color_white,
						size = panelwidth * 2
					})
				end
				local scroll_panel = vgui.Create( "DButton", DScrollPanel )
				scroll_panel:Dock( TOP )
				scroll_panel:SetText("")
				scroll_panel:DockMargin( 0,5,0,0 )
				scroll_panel:SetSize(0,width)
				//scroll_panel.clr = team.GetColor(v:Team())
				scroll_panel.clr = tab.color
				if not v.GetNClass then
					player_manager.RunClass( v, "SetupDataTables" )
				end
				-- MenuButtonOptions:AddOption("how", function() Msg("How") end )
				scroll_panel.DoRightClick = function()
						local Menu = DermaMenu()
						local target = v
						local ply = LocalPlayer()
						
						local profile = Menu:AddOption("Profile", function()
							if target:IsValid() then
								target:ShowProfile()
							end
						end)
						profile:SetIcon( "icon16/group.png" )
						
						
						if LocalPlayer():IsUserGroup(SCOREBOARD.AdminUsergroup) then-- Is the same as vgui.Create( "DMenu" )
							if !target:GetNWBool("ulx_gagged") then
								local gag = Menu:AddOption( "Gag", function()
									ply:ConCommand("ulx gag " .. target:Nick())
								end) -- Simple option, but we're going to add an icon
								gag:SetIcon( "icon16/wand.png" )	-- Icons are in materials/icon16 folder
							else
								local ungag = Menu:AddOption( "Ungag", function()
									ply:ConCommand("ulx ungag " .. target:Nick())
								end)
								ungag:SetIcon( "icon16/wand.png" )
							end

							if !target:GetNWBool("ulx_muted") then
								local mute = Menu:AddOption("Mute", function()
									ply:ConCommand("ulx mute " .. target:Nick())
								end)
								mute:SetIcon("icon16/sound.png")
							else
								local unmute = Menu:AddOption("Unmute", function()
									ply:ConCommand("ulx unmute " .. target:Nick())
								end)
								unmute:SetIcon("icon16/sound_mute.png")
							end
						end
						Menu:Open()
				end


				scroll_panel.Paint = function( self, w, h )
					
					if !IsValid(v) or not v then
						frameBg:Close()
						return
					end
					local txt = "ERROR"
					if not v.GetNClass then
						player_manager.RunClass( v, "SetupDataTables" )
					elseif v:GetNClass() == ROLE_RES or v:GetNClass() == ROLE_CLASSD then
						txt = "Personnel"
					else
						txt = GetLangRole(v:GetNClass())
					end
					local tcolor = scroll_panel.clr
					if LocalPlayer():Team() == TEAM_CHAOS or LocalPlayer():Team() == TEAM_CLASSD then
						if v:Team() == TEAM_CHAOS then
							txt = GetLangRole(ROLE_CHAOS)
							tcolor = Color(29, 81, 56)
						end
					end
					if v:Team() == TEAM_SCP then
						txt = "SCP Object"
					end
					draw.RoundedBox( 0, 0, 0, w, h, tcolor )
					draw.Text( {
						text = string.sub(v:Nick(), 1, 16),
						pos = { width + 2, h / 2 },
						font = "sb_names",
						color = tab.color2,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER
					})
					draw.RoundedBox( 0, (scroll_panel:GetWide()/2) - 87.5, 0, 175, h, Color(0,0,0,120) )
					draw.Text( {
						text = txt,
						pos = {scroll_panel:GetWide()/2, h / 2 },
						font = "sb_names",
						color = tab.color2,
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER
					})
					local panel_x = w / 1.1175
					local panel_w = w / 14
				end

				local MuteButton = vgui.Create( "DButton", scroll_panel )
				MuteButton:Dock(RIGHT)
				MuteButton:SetSize( width, width - 0 )
				MuteButton:SetText( "" )
				MuteButton.DoClick = function()
					v:SetMuted( !v:IsMuted() )
				end
				MuteButton.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255,255) )
				end

				local MuteIMG = vgui.Create( "DImage", MuteButton )
				MuteIMG.img = "materials/breach/unmute.png"
				MuteIMG:SetPos( MuteButton:GetPos() )
				MuteIMG:SetSize( MuteButton:GetSize() )
				MuteIMG:SetImage( "materials/breach/unmute.png" )
				MuteIMG.Think = function( self, w, h )
					if !IsValid(v) then return end
					if v:IsMuted() then
						self.img = "materials/breach/mute.png"	
					else
						self.img = "materials/breach/unmute.png"
					end
					self:SetImage( self.img )
				end

				local drawb = true
				for i,pnl in ipairs(panels) do
					local ping_panel = vgui.Create( "DLabel", scroll_panel )
					ping_panel:Dock( RIGHT )
					if i == 1 then
						ping_panel:DockMargin( 0, 0, 25, 0 )
					end
					ping_panel:SetSize(pnl.size, 0)
					ping_panel:SetText(pnl.text)
					ping_panel:SetFont("sb_names")
					ping_panel:SetTextColor(tab.color2)
					ping_panel:SetContentAlignment(5)
					if drawb then
						ping_panel.Paint = function( self, w, h )
							ping_panel:SetText(pnl.text)
							draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,120) )
						end
					end
					drawb = !drawb
				end

				local Avatar = vgui.Create( "AvatarImage", scroll_panel )
				Avatar:SetSize( width, width )
				Avatar:SetPos( 0, 0 )
				Avatar:SetPlayer( v, 32 )
			end
		end
	end
	
end

function GM:ScoreboardShow()
	ShowScoreBoard()
end

function GM:ScoreboardHide()
	if IsValid(frameBg) then
		frameBg:Close()
	end
end
