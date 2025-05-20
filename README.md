# [Beta] Debloat Exported Arrays Addon for Godot

![screenshot1](https://github.com/user-attachments/assets/5a17300e-4c65-4e9c-8af3-8067644192e5)

This plugin debloats the exported Arrays by removing the `Size:` and `> Resource` fields and
updating the UI colors for a better item hierarchy. This is a beta version because the method used to
achieve this relies on the UI system defined for each version. So this addon might not work for other
versions of Godot. This is a follow up of this issue: godotengine/godot#106576

> Works with Godot 4.4 - other versions not tested

## Why Are These Changes Made

- Size and Resource fields: They are barely usable in most cases and make the hierarchy way worse
- Grab menu: This field was emptied out (icon set to null), but you can use the empty space to move the items. This
feature must be implemented in the header of each item instead of an icon. Hiding it was better for
the visual hierarchy than having it.
- Delete and drop down buttons: They have become transparent (in background) to support the main feature and help the visual hierarchy
- Add Element button: This button was changed to be 1. visually more satisfying 2. Help with the visual hierarchy by being transparent in the normal mode. Also because of the nature of icons (you can't align them to the center I guess) I tried hiding the icon and using a "+" text instead.

This way only the necessary fields are bold, and the other buttons are in fact, secondary.

## How To Use

1. Install and activate the addon
2. Reload the project: Project > Reload Current Project
3. Now you're good to go. check the example scene to see the results.

## Attribution

Thanks to (kleonc)[https://github.com/kleonc], memeber of Godot who wrote the core of this addon. I added the styling
and UI updates.