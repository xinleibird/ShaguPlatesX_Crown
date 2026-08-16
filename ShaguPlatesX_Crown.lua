local addonName = "ShaguPlatesX_Crown"
local frame = CreateFrame("Frame")

local function GetPlateUnitToken(nameplate)
    if not nameplate then
        return nil
    end
    if nameplate.lastGuid then
        return nameplate.lastGuid
    end
    if nameplate.parent and nameplate.parent.GetName then
        return nameplate.parent:GetName(1)
    end
    return nil
end

local function TryOverrideEliteIcon(nameplate)
    if not nameplate or not nameplate.eliteicon or not nameplate.eliteicon:IsShown() then
        return
    end

    local unit = GetPlateUnitToken(nameplate)
    if not unit or UnitIsPlayer(unit) then
        return
    end

    local classification = UnitClassification(unit)
    if classification == "elite" then
        nameplate.eliteicon:SetTexture("Interface\\AddOns\\ShaguPlatesX_Crown\\img\\crown_64")
        nameplate.eliteicon:Show()
    elseif classification == "worldboss" or classification == "boss" then
        nameplate.eliteicon:SetTexture("Interface\\AddOns\\ShaguPlatesX_Crown\\img\\crown_65")
        nameplate.eliteicon:Show()
    elseif classification == "rare" or classification == "rareelite" then
        nameplate.eliteicon:SetTexture("Interface\\AddOns\\ShaguPlatesX_Crown\\img\\crown_66")
        nameplate.eliteicon:Show()
    end
end

local function HookNameplateUpdate()
    if not pfNameplates or not pfNameplates.OnDataChanged or frame.hooked then
        return
    end

    local oldOnDataChanged = pfNameplates.OnDataChanged
    pfNameplates.OnDataChanged = function(self, nameplate)
        oldOnDataChanged(self, nameplate)
        TryOverrideEliteIcon(nameplate)
    end

    frame.hooked = true
end

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event ~= "ADDON_LOADED" then
        return
    end

    if arg1 == "ShaguPlatesX" then
        HookNameplateUpdate()
    elseif arg1 == addonName then
        if _G["pfNameplates"] and _G["pfNameplates"].OnDataChanged then
            HookNameplateUpdate()
        end
    end
end)

if _G["pfNameplates"] and _G["pfNameplates"].OnDataChanged then
    HookNameplateUpdate()
end
