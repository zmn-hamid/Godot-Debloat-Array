@tool
extends EditorInspectorPlugin

var transparent_style_all: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_transparent.tres")
var button_style_hover: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_hover.tres")
var button_style_danger_normal: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_danger_normal.tres")
var button_style_danger_hover: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_danger_hover.tres")


func _init() -> void:
    var editor_tree: SceneTree = EditorInterface.get_base_control().get_tree()
    editor_tree.node_added.connect(on_editor_node_added)

func get_settings_resource_group() -> bool:
    return EditorInterface.get_editor_settings().get_setting('addons/debloat_array/process_resource_group')

func get_settings_size_field() -> bool:
    return EditorInterface.get_editor_settings().get_setting('addons/debloat_array/process_size_field')

func on_editor_node_added(node: Node) -> void:
    if node.get_class() == "EditorPropertyArray":
        node.child_entered_tree.connect(func(node: Node) -> void:
            if node is PanelContainer:
                var main := func() -> void:
                    ## the "Size:" field
                    if get_settings_size_field():
                        for lbl: Label in find_nodes_by_type_and_text(node, "Label", "Size:"):
                            lbl.get_parent().hide()

                    ## the Add Element button
                    for btn: Button in find_nodes_by_type_and_text(node, "Button", "Add Element"):
                        btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                        btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
                        btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
                        btn.text = '+'
                        btn.icon = null
                        btn.add_theme_stylebox_override("normal", transparent_style_all)
                        btn.add_theme_stylebox_override("hover", button_style_hover)
                        btn.pressed.connect(_on_connect.bind(node))
                    
                    for erp: EditorResourcePicker in find_nodes_by_type_and_text(node, "EditorResourcePicker", ""):
                        var row = erp.get_parent().get_parent()

                        ## the grab (hamburgur) button
                        var grab_btn = row.get_child(0)
                        if grab_btn is Button:
                            grab_btn.text = ''
                            grab_btn.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
                            override_styleboxes(grab_btn, transparent_style_all)
                        
                        ## the delete button
                        var delete_btn = row.get_child(-1)
                        if delete_btn is Button:
                            delete_btn.add_theme_stylebox_override("normal", button_style_danger_normal)
                            delete_btn.add_theme_stylebox_override("hover", button_style_danger_hover)
                            delete_btn.reparent(erp)

                        ## the drop down button
                        var drop_down_btn = erp.get_child(-2)
                        if drop_down_btn is Button:
                            drop_down_btn.hide()
                main.call_deferred()
        )

func find_nodes_by_type_and_text(parent: Node, type: String, text: String) -> Array:
    var results: Array = []
    if parent.get_class() == type:
        if text != '' and parent.get("text") == text:
            results.append(parent)
        elif text == '':
            results.append(parent)
    for child in parent.get_children():
        results.append_array(find_nodes_by_type_and_text(child, type, text))
    return results

func override_styleboxes(node: Node, style_box: StyleBox) -> void:
    node.add_theme_stylebox_override("normal", style_box)
    node.add_theme_stylebox_override("hover", style_box)
    node.add_theme_stylebox_override("pressed", style_box)
    node.add_theme_stylebox_override("focus", style_box)

func _on_connect(node: Node):
    var nil_properties = find_nodes_by_type_and_text(node, "EditorPropertyNil", "")
    var new_item: Node
    if nil_properties:
        var first_nil_hbox: Node = nil_properties[0].get_parent()
        new_item = first_nil_hbox.get_parent().get_children()[first_nil_hbox.get_index() - 1]
        print(new_item.get_tree_string_pretty())
        # print(new_item.get_parent().get_tree_string_pretty())

    # for child in node.get_children().slice(1, 1000):
    var child = new_item
    # ## the "Size:" field
    # if get_settings_size_field():
    #     for lbl: Label in find_nodes_by_type_and_text(child, "Label", "Size:"):
    #         lbl.get_parent().hide()
    
    # ## the Add Element button
    # for btn: Button in find_nodes_by_type_and_text(child, "Button", "Add Element"):
    #     btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    #     btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
    #     btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
    #     btn.text = '+'
    #     btn.icon = null
    #     btn.add_theme_stylebox_override("normal", transparent_style_all)
    #     btn.add_theme_stylebox_override("hover", button_style_hover)
    #     btn.pressed.connect(_on_connect.bind(child))
    
    for erp: EditorResourcePicker in find_nodes_by_type_and_text(child, "EditorResourcePicker", ""):
        var row = erp.get_parent().get_parent()

        ## the grab (hamburgur) button
        var grab_btn = row.get_child(0)
        if grab_btn is Button:
            grab_btn.text = ''
            grab_btn.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
            override_styleboxes(grab_btn, transparent_style_all)
        
        ## the delete button
        var delete_btn = row.get_child(-1)
        if delete_btn is Button:
            delete_btn.add_theme_stylebox_override("normal", button_style_danger_normal)
            delete_btn.add_theme_stylebox_override("hover", button_style_danger_hover)
            delete_btn.reparent(erp)

        ## the drop down button
        var drop_down_btn = erp.get_child(-2)
        if drop_down_btn is Button:
            drop_down_btn.hide()

func _can_handle(object: Object) -> bool:
    return true

func _parse_end(object: Object) -> void:
    if get_settings_resource_group():
        if object is Resource:
            add_custom_control(ResourceGroupHider.new())

class ResourceGroupHider:
    extends Control
    
    func _ready() -> void:
        ## resource group
        var resource_group_container: Control = get_parent().get_child(-2)
        resource_group_container.hide()
        queue_free()
