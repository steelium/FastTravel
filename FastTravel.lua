-- Thanks to ReCover for making the MapCoords addon
-- Much of getting and showing map coordinates was extracted
-- from his addon
--
-- - Version 0.1

function round(float)
	return floor(float+0.5)
end

function FastTravel()
  print("FastTravel addon loaded! (v0.1)");
  print("Press ';' when you're on the map to teleport near your cursor!");
  --SendAddonMessage("S:FastTravel", "Message here", "GUILD");
end

function ft_mouseDown()
    print("FT Mouse Down");
end

function ft_mdu()
    print("ft_mdu")
end

function ft_mdo()
    print("ft_mdo")
end

function getzones(cont)
    for x in GetMapZones(cont) do
		print("Zone: " .. x);
	end
end
    

function ft_kdo(frame, key)
    if (key) then
        --print ("key is " .. key)
    end
    if (key == ";") then
        local continent = GetCurrentMapContinent()
        local zone = GetCurrentMapZone()
        local areaID = GetCurrentMapAreaID()
        local Zones = { GetMapZones(continent) };
        --[[ print("Area: " .. areaID)
        print("Continent: " .. continent)
        print("Zone: " .. zone)
        print ("Zone: " .. Zones[zone]); ]]
        local scale = WorldMapDetailFrame:GetEffectiveScale()
        local width = WorldMapDetailFrame:GetWidth()
        local height = WorldMapDetailFrame:GetHeight()
        local centerX, centerY = WorldMapDetailFrame:GetCenter()
        local x, y = GetCursorPosition()
        -- Tweak coords so they are accurate
        local adjustedX = (x / scale - (centerX - (width/2))) / width
        local adjustedY = (centerY + (height/2) - y / scale) / height
        
       

        if (zone > 0 and adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
            adjustedX = adjustedX * 100
            adjustedY = adjustedY * 100
            local msg = ".fasttravel " .. adjustedX .. " " .. adjustedY .. " " .. (areaID - 1)
            SendChatMessage(msg, "SAY")
            print ("TELEPORT to " .. adjustedX .. " " .. adjustedY .. " " .. (areaID - 1))
            
            --SendAddonMessage("FastTravel", "go to x y at z", "GUILD");

        end
    else
        WorldMapFrame_OnKeyDown(frame, key)
    end
end

function FastTravel_OnLoad(self)
    if (self) then
        print ("OnLoad " .. self);
    end
    local frame = getglobal("WorldMapZoneInfo")
    if (not frame) then
        print ("No frame!")
    else
        -- frame:RegisterEvent("OnMouseDown")
        -- frame:SetScript("OnMouseDown", ft_mouseDown)
    end
    print ("OnLoad");

    --WorldMapFrame:RegisterEvent("OnMouseDown");
    --WorldMapFrame:SetScript("OnMouseDown", ft_mouseDown);
end

function FastTravelMapButton_OnClick()
    print("Clicked Map Button");
end

function FastTravelMap_OnClick()
    print("Map clicked");
end

function FastTravelGetMousePosition()
    local scale = WorldMapDetailFrame:GetEffectiveScale()
    local width = WorldMapDetailFrame:GetWidth()
    local height = WorldMapDetailFrame:GetHeight()
    local centerX, centerY = WorldMapDetailFrame:GetCenter()
    local x, y = GetCursorPosition()
    -- Tweak coords so they are accurate
    local adjustedX = (x / scale - (centerX - (width/2))) / width
    local adjustedY = (centerY + (height/2) - y / scale) / height		

    -- Write output
    if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <=1 and adjustedY <=1) then
        output = MAPCOORDS_SLASH4..fmtCrd(adjustedX).." / "..fmtCrd(adjustedY)
    end
end

function fmtCrd(coord)
    --if (MapCoords2["show decimals"] == true) then
		return format("%1.1f", round(coord * 1000) / 10)
	--else
    --return round(num * 100)
	--end
end

function FastTravelWorldMap_OnUpdate()
	local output = ""
	--if (MapCoords2["worldmap cursor"] == true) then
		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		-- Tweak coords so they are accurate
		local adjustedX = (x / scale - (centerX - (width/2))) / width
        local adjustedY = (centerY + (height/2) - y / scale) / height		
	
		-- Write output
		if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <=1 and adjustedY <=1) then
            output = "Cursor: "..fmtCrd(adjustedX).." / "..fmtCrd(adjustedY)
        end
	--end
	--if (MapCoords2["worldmap cursor"] == true and MapCoords2["worldmap player"]) then
        if (output ~= "") then
            output = output.." -- "
        end
    --end
	--if (MapCoords2["worldmap player"] == true) then
		local px, py = GetPlayerMapPosition("player")
		if ( px == 0 and py == 0 ) then
            output = output.."Player: ".."n/a"
		else
            output = output.."Player: "..fmtCrd(px).." / "..fmtCrd(py)
        end
	--end
        local areaID = GetCurrentMapAreaID() - 1
    if (output ~= "" and areaID > 0) then
        output = output.." -- Map ID: "..areaID
    end
    --[[if (scale < 0.60) then
        FastTravelWorldMap:SetPoint("BOTTOM", 100)
    else
        FastTravelWorldMap:SetPoint("BOTTOM", 20)
    end]]
   	FastTravelWorldMap:SetText(output)
end


