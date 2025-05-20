# [Beta] Debloat Exported Arrays Addon for Godot

![screenshot1](https://github.com/user-attachments/assets/f8e02ba7-019c-42c8-bbda-b2a67a15a99a)

This plugin debloats the exported Arrays by removing the `Size:` and `> Resource` fields and
updating the UX. This is a beta version because the method used to achieve this relies on the UI system defined for each version. So this addon might not work for other versions of Godot. This is a follow up of this issue: godotengine/godot#106576

> Works with Godot 4.4 - other versions not tested

## Why Are These Changes Made

Note: You can disable any of these that you want. I'm just explaining why these are the defaults.

- Size and Resource fields: They are barely usable in most cases and make the hierarchy way worse
- Grab and drop down buttons: These buttons are a secondary, therefore they must've become transparent to respect the visual hirearchy. The grab button was way better if it was inside the item row, behind the index number. But any changes I tried to make was overriden.
- Delete button: It's too distracting and large in the original version, which messes with the hierarchy. It's just a button to delete each item, so I put it next to the item header.
- Add Element button: This button is secondary therefore transparent, and on hover becomes colorful to give feedback (the same as the delete button). Also because you can't center a button icon, I set the icon to null and used "+" as the text for it.

## How To Use

1. Install and activate the addon
2. Reload the project: Project > Reload Current Project
3. Now you're good to go. check the example scene to see the results.

**Important Note**: Because of the hacky nature of this version, you'll see mismatches when you add new items. Try folding and unfolding for the changes to take effect

## How To Customize

- You can change the variables in the beginning of [debloat_array_inspector.gd file](addons/debloat_array/debloat_array_inspector.gd) to turn off/on each feature you want.
- You can change the styleboxes in `addons/debloat_array/styles/` to customize the looks.

## Attribution

Thanks to (kleonc)[https://github.com/kleonc], memeber of Godot who wrote the core of this addon (the size and resource fields)

## License

MIT