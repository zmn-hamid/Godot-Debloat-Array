@tool
extends EditorPlugin

var inspector_plugin = null

func _enter_tree():
    inspector_plugin = preload("debloat_array_inspector.gd").new()
    add_inspector_plugin(inspector_plugin)

func _exit_tree():
    if inspector_plugin:
        remove_inspector_plugin(inspector_plugin)
        inspector_plugin = null
