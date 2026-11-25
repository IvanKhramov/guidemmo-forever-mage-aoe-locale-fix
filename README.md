# GuideMMO Forever Mage AOE - RU

Add-on for [GuideMMO Forever Mage AOE](https://www.curseforge.com/wow/addons/guidemmo-forever-mage-aoe)
that fixes the **Show on map** button on non-English WoW Forever clients (Russian, German, French and others).

Made by a third party, not affiliated with the original author. Contains no code or data from the original addon.

## The problem

The original addon finds a spot's map by comparing the English zone name from its data
with `C_Map.GetMapInfo(id).name`. On a non-English client the API returns localized names,
so the lookup fails with an error like `could not find a map named: Westfall`.

## How it works

The add-on knows the `UiMapID` of every zone used by the guide. It asks the game
for the zone name in the client's language and puts it first in the spot's list of zone names.
English names stay in the list, coordinates and saved waypoints are untouched.
On an English client nothing changes.

## Install

1. Install the original addon.
2. Download the zip from [Releases](https://github.com/IvanKhramov/guidemmo-forever-mage-aoe-ru/releases)
   and extract `GuidemmosMageAOEGuide_RU` into `Interface/AddOns`.
3. `/reload`.

Only zone names are localized. Buttons, tabs and spot descriptions stay in English.

## Tracking the original addon

A daily GitHub Action ([check-upstream](.github/workflows/check-upstream.yml)) looks for new
files of the original on CurseForge. For each new file it opens an issue saying whether
every zone in its `Data.lua` is covered by `MapLocale.lua`.
`upstream-file-id` holds the CurseForge file ID of the original release this add-on was last checked against.

Run the check locally: `.github/scripts/check-upstream.sh`.

## На русском

Дополнение к GuideMMO Forever Mage AOE. Чинит кнопку **Show on map**
в неанглийских клиентах WoW Forever: оригинал ищет зону по английскому имени и не находит,
например, «Западный Край». Дополнение подставляет названия зон на языке клиента по `UiMapID`.
Ставится рядом с оригиналом в `Interface/AddOns`, после установки `/reload`.

## License

MIT
