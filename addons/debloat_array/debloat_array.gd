@tool
extends EditorPlugin

var inspector_plugin = null

var editor_settings = get_editor_interface().get_editor_settings()
var setting_names := []

func _enter_tree():
    inspector_plugin = preload("debloat_array_inspector.gd").new()
    add_inspector_plugin(inspector_plugin)

    var setting_name := 'addons/debloat_array/process_size_field'
    setting_names.append(setting_name)
    if not editor_settings.has_setting(setting_name):
        editor_settings.set_setting(setting_name, true)

    setting_name = 'addons/debloat_array/process_resource_group'
    setting_names.append(setting_name)
    if not editor_settings.has_setting(setting_name):
        editor_settings.set_setting(setting_name, true)

func _exit_tree():
    if inspector_plugin:
        remove_inspector_plugin(inspector_plugin)
        inspector_plugin = null
    for setting_name in setting_names:
        editor_settings.erase(setting_name)
