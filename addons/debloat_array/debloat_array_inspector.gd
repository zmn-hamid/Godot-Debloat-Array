@tool
extends EditorInspectorPlugin

### Edit the variables bellow for customization ###
#
var process_size_field: bool = true # the "Size:" field
var process_resource_group: bool = true # the `> Resource` group under each resource
var process_grab_button: bool = true # the hamburgur button used for reordering
var process_drop_down_button: bool = true # the resource drop down (picker) button
var process_delete_button: bool = true # the delete button
var process_add_element_field: bool = true # the "+ Add Element Field"
#
###################################################

func _init() -> void:
    var editor_tree: SceneTree = EditorInterface.get_base_control().get_tree()
    editor_tree.node_added.connect(on_editor_node_added)

func on_editor_node_added(node: Node) -> void:
    if node.get_class() == "EditorPropertyArray":
        node.child_entered_tree.connect(func(child: Node) -> void:
            if child is PanelContainer:
                var transparent_style_all: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_transparent.tres")
                var button_style_hover: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_hover.tres")
                var button_style_danger_normal: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_danger_normal.tres")
                var button_style_danger_hover: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_danger_hover.tres")

                var size_label_container: HBoxContainer
                var add_element_button: Button
                var hamburgur_toggle_button: Button
                var delete_button: Button
                var drop_down_button # Label or EditorResourcePicker
                var drop_down_button_container

                var main := func() -> void:
                    ## the "Size:" field
                    if process_size_field:
                        size_label_container = find_node_by_tree_text(child.get_child(0),
                            '┖╴HBoxContainer/    ┠╴Label/    ┖╴EditorSpinSlider/       ┖╴TextureRect//')[0]
                        size_label_container.hide()
                    

                    ## the Add Element button
                    if process_add_element_field:
                        add_element_button = find_node_by_tree_text(child.get_child(0),
                            '┖╴Button//', true, false, false, [])[0]
                        add_element_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                        add_element_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
                        add_element_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
                        add_element_button.text = '+'
                        add_element_button.icon = null
                        add_element_button.add_theme_stylebox_override("normal", transparent_style_all)
                        add_element_button.add_theme_stylebox_override("hover", button_style_hover)

                    var items_container: Node = child.get_child(0).get_child(1)
                    print('----')
                    for item: Node in find_node_by_tree_text(items_container,
                            '┖╴HBoxContainer/    ┠╴Button/    ┠╴EditorPropertyNil/    ┃  ┖╴Label/',
                            false, true, false, []):
                        # extra check
                        if not get_clean_tree(item).ends_with('┖╴Button//'):
                            continue
                        
                        ## the grab (hamburgur) button
                        if process_grab_button:
                            hamburgur_toggle_button = find_node_by_tree_text(item,
                                "┖╴Button//", false, false, true, [])[0]
                            hamburgur_toggle_button.text = ''
                            hamburgur_toggle_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
                            override_styleboxes(hamburgur_toggle_button, transparent_style_all)

                        ## the delete button
                        if process_delete_button:
                            delete_button = find_node_by_tree_text(item,
                                "┖╴Button//", true, false, true, [])[0]
                            delete_button.add_theme_stylebox_override("normal", button_style_danger_normal)
                            delete_button.add_theme_stylebox_override("hover", button_style_danger_hover)

                        ## the drop down button
                        if process_drop_down_button:
                            drop_down_button_container = find_node_by_tree_text(item,
                                "┖╴EditorPropertyResource/    ┖╴EditorResourcePicker/       ┠╴Button/", false, true, false, [])
                            if drop_down_button_container:
                                drop_down_button = drop_down_button_container[0].get_child(0)
                                override_styleboxes(drop_down_button.get_child(-1), transparent_style_all)
                                if process_delete_button:
                                    delete_button.reparent(drop_down_button)
                main.call_deferred()
        )

func override_styleboxes(node: Node, style_box: StyleBox) -> void:
    node.add_theme_stylebox_override("normal", style_box)
    node.add_theme_stylebox_override("hover", style_box)
    node.add_theme_stylebox_override("pressed", style_box)
    node.add_theme_stylebox_override("focus", style_box)

func find_node_by_tree_text(parent: Node,
                            text: String,
                            reverse: bool = false,
                            startswith: bool = false,
                            recursive: bool = true,
                            total: Array = []) -> Array:
    var children: Array[Node] = parent.get_children()
    if reverse:
        children.reverse()
    for child: Node in children:
        var clean_tree: String = get_clean_tree(child)
        if (startswith and clean_tree.begins_with(text)) or (!startswith and clean_tree == text):
            total.append(child)
        if recursive:
            return find_node_by_tree_text(child, text, reverse, startswith, recursive, total)
    return total

func get_clean_tree(node: Node) -> String:
    var new_text: String = ''
    for line in node.get_tree_string_pretty().split('\n'):
        var new_line: String = ''
        for part in line.split('@'):
            if !(part == '' or part.is_valid_int()):
                new_line += part
        new_text += new_line + '\\'
    return new_text.strip_edges().replace('\\', '/')

func _can_handle(object: Object) -> bool:
    return true

func _parse_end(object: Object) -> void:
    if process_resource_group:
        if object is Resource:
            add_custom_control(ResourceGroupHider.new())

class ResourceGroupHider:
    extends Control
    
    func _ready() -> void:
        ## resource group
        var resource_group_container: Control = get_parent().get_child(-2)
        resource_group_container.hide()
        queue_free()