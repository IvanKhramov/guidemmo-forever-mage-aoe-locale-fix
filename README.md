# GuideMMO Forever Mage AOE - Locale Fix

> **Deprecated.** Since version 2.0 the original addon looks up maps by ID and is translated
> into 10 languages, so this add-on is no longer needed. Uninstall it and update
> [GuideMMO Forever Mage AOE](https://www.curseforge.com/wow/addons/guidemmo-forever-mage-aoe).
> Keeping it installed next to 2.0 does no harm.

Add-on for [GuideMMO Forever Mage AOE](https://www.curseforge.com/wow/addons/guidemmo-forever-mage-aoe)
that fixes the **Show on map** button on non-English WoW Forever clients.

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
2. Install this add-on from [CurseForge](https://www.curseforge.com/wow/addons/guidemmo-forever-mage-aoe-ru),
   or download the zip from [Releases](https://github.com/IvanKhramov/guidemmo-forever-mage-aoe-locale-fix/releases)
   and extract `GuidemmosMageAOEGuide_LocaleFix` into `Interface/AddOns`.
3. `/reload`.

Upgrading from 0.2.0 or older: delete the old `GuidemmosMageAOEGuide_RU` folder.

Only zone names are localized. Buttons, tabs and spot descriptions stay in English.

## Tracking the original addon

A daily GitHub Action ([check-upstream](.github/workflows/check-upstream.yml)) looks for new
files of the original on CurseForge. For each new file it opens an issue saying whether
every zone in its `Data.lua` is covered by `MapLocale.lua`.
`upstream-file-id` holds the CurseForge file ID of the original release this add-on was last checked against.

Run the check locally: `.github/scripts/check-upstream.sh`.

## License

MIT
