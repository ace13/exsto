--[[
	Exsto
	Copyright (C) 2013  Prefanatic

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- Exsto Panel Scroller

PANEL = {}

function PANEL:Init()

	self.Objects = {}
	
	self.Material = Material( "exsto/gradient.png" )
	
	self.List = vgui.Create( "DCategoryList", self )
		self.List:Dock( FILL )
		self.List:DockMargin( 4, 0, 4, 0 )
		self.List.pnlCanvas:DockPadding( 2, 5, 2, 5 )
		self.List.VBar:SetWide( 3 )
		self.List.PaintOver = function( pnl )
			surface.SetMaterial( self.Material )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 0, 0, pnl:GetWide(), 9 )
		end
		self.List.Paint = function( pnl )
			pnl:GetSkin().tex.Input.ListBox.Background( 0, 0, pnl:GetWide(), pnl:GetTall() );
		end

	self._VBarDisabled = false
	
end

function PANEL:Paint()
	
end

function PANEL:Think()
	--if self.List.VBar:IsVisible() and self._VBarDisabled then print( "Fixing vbar" ) self:DisableScroller() end
	--if !self.List.VBar:IsVisible() and !self._VBarDisabled then print( "drgu" ) self.List.VBar:SetEnabled( true ) end
end

function PANEL:DisableScroller()
	--self.List.VBar:SetEnabled( false )
	self.List.VBar:SetVisible( false )
	self.List.VBar.Enabled = false
	self._VBarDisabled = true
end

-- Deprecating
function PANEL:Add( obj, catName )
	if !self.Objects[ catName ] then self.Objects[ catName ] = {} end
	
	local cat = self.Categories[ catName ]

	table.insert( self.Objects[ catName ], obj )
end

local function categoryPaint( cat )
	surface.SetFont( "ExGenericText19" )
	local w, h = surface.GetTextSize( cat.Header:GetValue() )
	
	surface.SetDrawColor( 195, 195, 195, 195 )
	surface.DrawLine( w + 15, ( cat.Header:GetTall() / 2 ), cat.Header:GetWide() - 5, ( cat.Header:GetTall() / 2 ) )
end

local function createTitle( o, txt )
	local title = vgui.Create( "ExText", o )
		title:SetText( txt )
		title:SetFont( "ExGenericText18" )
		title:SetTextColor( Color( 0, 180, 255, 255 ) )
		title:Dock( TOP )
	return title
end

local function createHelp( o, txt )
	local help = vgui.Create( "ExText", o )
		help:SetText( txt )
		help:SetFont( "ExGenericText14" )
		help:Dock( TOP )
	return help
end

local function createButton( o, txt )
	local button = vgui.Create( "ExQuickButton", o )
		button:Text( txt )
		button:Dock( TOP )
	return button
end

local function createMultichoice( o )
	local button = vgui.Create( "ExVarMultiChoice", o )
		button:Dock( TOP )
		button:SetTall( 40 )
		button:SetHeaderSize( 40 )
	return button
end

local function setHideable( o, b )
	if b then o.Header.DoClick = o.Header._OldDoClick return end
	o.Header.DoClick = function() end
end

function PANEL:CreateCategory( catName )
	self.Categories = self.Categories or {}

	local cat = self.List:Add( catName )
		cat.Header:SetTextColor( Color( 0, 180, 255, 255 ) )
		cat.Header:SetFont( "ExGenericText20" )
		cat.Header.UpdateColours = function( self, skin ) end
		cat.Header._OldDoClick = cat.Header.DoClick
		cat.Header.DoClick = function() end
		cat.Think = function() end -- To prevent gmod's derma animations
		cat.Paint = categoryPaint
		
		-- Animation overrides
		--cat.animSlide.Start = function() end
		--cat.animSlide.Run = function() end
		
		--[[cat.Toggle = function( s )
			if s:GetExpanded() then -- We need to close.
				print( "Goign to header" )
				s:SetTall( s.Header:GetTall() )
			else -- Need to open
				print( "Going to children" )
				
				-- This is stupid, but I think we have to do it.
				local t = 0
				for _, obj in ipairs( s:GetChildren() ) do
					t = t + obj:GetTall() + 4 -- 4 padding?
				end
				print( t )
				s:SetTall( t )
			end
			print( "RUNNING :))))))))))))))" )
			s:SetExpanded( !s:GetExpanded() )
			s:InvalidateLayout( true )
		end]]
		
		--[[cat.animSlide.Func = function( s, anim, delta, data )
			print( "Doing something?" )
		end]] 
		
		cat.CreateMultiChoice = createMultichoice
		cat.SetHideable = setHideable
		cat.CreateButton = createButton
		cat.CreateTitle = createTitle
		cat.CreateHelp = createHelp
		cat.CreateSpacer = function( c )
			local spacer = vgui.Create( "ExSpacer", c )
				spacer:Dock( TOP )
				spacer:SetTall( 10 )
			return spacer
		end
		
	cat:DockPadding( 4, 0, 4, 0 )
	
	--exsto.Animations.Create( cat )
	self.Categories[ catName ] = cat
	
	return cat
end

function PANEL:PerformLayout()

end
	

derma.DefineControl( "ExPanelScroller", "Exsto Panel Scroller", PANEL, "DPanel" )