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

-- Exsto Number Choice

PANEL = {}

function PANEL:Init()

	self:SetAlignX( TEXT_ALIGN_LEFT )
	self:SetMaxTextWide( 166 )
	self:MaxFontSize( 28 )
	
	-- Create our slider.
	self.Scratch = self:Add( "DNumberScratch", self )
		self.Scratch:SetImageVisible( false )
		self.Scratch:SetText( "" )
		self.Scratch:Dock( FILL )
		--self.Scratch:SetDark( true )
		
		self.Scratch:SetDecimals( nil )
		self.Scratch.OnValueChanged = function( o, val )
			val = tonumber( Format( "%i", o:GetFloatValue() ) )
			self.Entry:SetValue( val or 0 )
			self:OnValueSet( val )
		end
		self.Scratch.UpdateConVar = function() end
		
		
	-- Text entry for the value
	self.Entry = self:Add( "DTextEntry" )
		self.Entry:DockMargin( 4, 4, 4, 4 )
		self.Entry:Dock( RIGHT )
		self.Entry:SetNumeric( true )
		self.Entry.OnTextChanged = function( o, val )
			self.Scratch:SetValue( o:GetValue() )
			self:OnValueSet( o:GetValue() )
		end

end

function PANEL:SetDecimals( d ) self.Scratch:SetDecimals( d ) end

function PANEL:SetMinMax( min, max ) 
	self.Scratch:SetMin( min )
	self.Scratch:SetMax( max )
end
function PANEL:SetMin( min ) self.Scratch:SetMin( min ) end
function PANEL:SetMax( max ) self.Scratch:SetMax( max ) end
function PANEL:SetValue( val )
	self.Scratch:SetValue( val )
	self.Entry:SetValue( val ) 
end
function PANEL:GetValue() return self.Scratch:GetValue() end

function PANEL:OnValueSet( val ) end

function PANEL:Paint()
	local w, h = self:GetSize()
	
	if self.Hovered then
		self:GetSkin().tex.Input.ComboBox.Hover( 0, 0, w, h )
	else
		self:GetSkin().tex.Input.ComboBox.Normal( 0, 0, w, h )
	end
	
	if !self._HideText then
		
		-- Text
		local x = self:GetWide() / 2
		local y = self:GetTall() / 2
		
		if self._AlignX == TEXT_ALIGN_LEFT then x = self:GetTextPadding() end
		
		--if self._AlignY == TEXT_ALIGN_TOP then y = y + self._YMod end
		
		draw.SimpleText( self:GetText(), self:GetFont() .. self:GetFontSize(), x, y, self:GetTextColor(), self._AlignX, self._AlignY )
		
	end
end

derma.DefineControl( "ExNumberChoice", "Exsto Number Choice", PANEL, "ExButton" )