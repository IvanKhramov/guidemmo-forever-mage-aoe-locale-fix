# GuideMMO Forever Mage AOE - RU

Unofficial plugin for [GuideMMO Forever Mage AOE](https://www.curseforge.com/wow/addons/guidemmo-forever-mage-aoe)
that fixes the **Show on map** button on the Russian (ruRU) WoW Forever client.

Not affiliated with the author of the original addon. Contains no code or data from it.

## The problem

The original addon finds a spot's map by comparing the English zone name from its data
with `C_Map.GetMapInfo(id).name`. On a ruRU client the API returns Russian names,
so the lookup fails with an error like `could not find a map named: Westfall`.

## How it works

The plugin knows the `UiMapID` of every zone used by the guide. On ruRU it asks the game
for the localized zone name and puts it first in the spot's list of zone names.
English names stay in the list, coordinates and saved waypoints are untouched.
On other locales the plugin does nothing.

## Install

1. Install the original addon.
2. Download the zip from [Releases](https://github.com/IvanKhramov/guidemmo-forever-mage-aoe-ru/releases)
   and extract `GuidemmosMageAOEGuide_RU` into `Interface/AddOns`.
3. `/reload`.

Only zone names are localized. Buttons, tabs and spot descriptions stay in English.

## На русском

Неофициальный плагин к GuideMMO Forever Mage AOE. Чинит кнопку **Show on map**
в русском клиенте WoW Forever: оригинал ищет зону по английскому имени и не находит
«Западный Край». Плагин подставляет русские названия зон по `UiMapID`.
Ставится рядом с оригиналом в `Interface/AddOns`, после установки `/reload`.

## License

MIT
