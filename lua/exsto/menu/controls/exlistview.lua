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

-- Exsto List View

PANEL = {}

function PANEL:Init()

	-- Data for OnRowSelected
	self.Data = {}

end

function PANEL:NoHeaders()
	self:SetHideHeaders( true )
	self:AddColumn( "" )
end

function PANEL:AddRow( cols, data )
	
	local line = self:AddLine( unpack( cols ) )
	table.insert( self.Data, { Data = data, Display = { unpack( cols ) } } ) -- It will match up with the lineID.  I think.  :I
	
	return line

end

function PANEL:GetLineData( disp )
	for id, linedata in ipairs( self.Data ) do
		if linedata.Display == disp then return linedata.Data end
	end
	return nil
end

function PANEL:GetLineObj( disp )
	for id, linedata in ipairs( self.Data ) do
		if linedata.Display == disp then return self:GetLine( id ) end
	end
	return nil
end	

function PANEL:LineSelected( disp, data, lineobj )
	
end

function PANEL:OnRowSelected( lineID, line )
	local disp = self.Data[ lineID ].Display
	local data = self.Data[ lineID ].Data
	
	self:LineSelected( disp, data, line )
end

derma.DefineControl( "ExListView", "Exsto ListView", PANEL, "DListView" )