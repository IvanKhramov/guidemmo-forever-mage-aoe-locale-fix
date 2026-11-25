if GetLocale() ~= "ruRU" or type(GuidemmosMageAOEData) ~= "table" then
    return
end

-- Zone UiMapIDs in WoW Forever.
local mapIDs = {
    ["Alterac Mountains"] = 1416,
    ["Arathi Highlands"] = 1417,
    ["The Barrens"] = 1413,
    ["Duskwood"] = 1431,
    ["Dustwallow Marsh"] = 1445,
    ["Felwood"] = 1448,
    ["Hillsbrad Foothills"] = 1424,
    ["Redridge Mountains"] = 1433,
    ["Silverpine Forest"] = 1421,
    ["Swamp of Sorrows"] = 1435,
    ["Tanaris"] = 1446,
    ["Un'Goro Crater"] = 1449,
    ["Western Plaguelands"] = 1422,
    ["Westfall"] = 1436,
    ["Wetlands"] = 1437,
}

-- The guide accepts multiple names per zone and displays the first one.
for _, spot in ipairs(GuidemmosMageAOEData) do
    local names = type(spot.zone) == "table" and spot.zone or { spot.zone }
    local mapID = mapIDs[names[1]]
    local info = mapID and C_Map.GetMapInfo(mapID)
    if info and info.name and info.name ~= names[1] then
        local localizedNames = { info.name }
        for _, name in ipairs(names) do
            if name ~= info.name then
                localizedNames[#localizedNames + 1] = name
            end
        end
        spot.zone = localizedNames
    end
end
