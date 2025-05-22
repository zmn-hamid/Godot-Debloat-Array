# [Pre-Stable Version] Debloat Exported Arrays Addon for Godot

![screenshot1](https://github.com/user-attachments/assets/f8e02ba7-019c-42c8-bbda-b2a67a15a99a)

This plugin debloats the exported Arrays by removing the `Size:` and `> Resource` fields and
updating the UX. This is a follow up of this issue: godotengine/godot#106576

## Why Are These Changes Made

- Size and Resource fields: They are barely usable in most cases and make the hierarchy way worse. You can however, disable them. Check the "How To Customize" section bellow.
- Grab and drop down buttons: These buttons are a secondary, therefore they must've become transparent to respect the visual hirearchy. The grab button was way better if it was inside the item row, behind the index number. But any changes I tried to make was overriden.
- Delete button: It's too distracting and large in the original version, which messes with the hierarchy. It's just a button to delete each item, so I put it next to the item header.
- Add Element button: This button is secondary therefore transparent, and on hover becomes colored to give feedback (the same as the delete button). Also because you can't center a button icon, I set the icon to null and used "+" as the text for it.

## How To Use

1. Install and activate the addon
2. Reload the project: Project > Reload Current Project
3. Now you're good to go. check the example scene to see the results.

## Known Issues

- When adding a new item, most of the buttons seem unaffected. Try folding and unfolding the section for it to take in the effects.

## Improvements needed

- Horizontal padding is needed for the nested items.

## How To Customize

- To change the settings for the plugin, visit "Editor Settings > Addons > Debloat Array"
- You can change the styleboxes in `addons/debloat_array/styles/` to customize the looks.

## Attribution

Thanks to (kleonc)[https://github.com/kleonc], memeber of Godot who wrote the core of this addon
