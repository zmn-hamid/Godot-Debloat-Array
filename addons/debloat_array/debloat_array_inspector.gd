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
        node.child_entered_tree.connect(func(child: Node) -> void:
            if child is PanelContainer:
                var main := func() -> void:
                    ## the "Size:" field
                    if get_settings_size_field():
                        var size_label_container = find_node_by_pattern(
                            child.get_child(0), {
                                "type": "HBoxContainer",
                                "children": [
                                    {
                                        "type": "Label"
                                    },
                                    {
                                        "type": "EditorSpinSlider",
                                        "children": [
                                            {
                                                "type": "TextureRect"
                                            }
                                        ]
                                    }
                                ]
                            }
                        )
                        size_label_container.hide()
                    
                    var delete_button: Button

                    ## the Add Element button
                    var add_element_button: Button = find_node_by_pattern_bottom_up(
                        child.get_child(0), {
                            "type": "Button"
                        }, false,
                    )
                    add_element_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                    add_element_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
                    add_element_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
                    add_element_button.text = '+'
                    add_element_button.icon = null
                    add_element_button.add_theme_stylebox_override("normal", transparent_style_all)
                    add_element_button.add_theme_stylebox_override("hover", button_style_hover)

                    var vbox = find_node_by_pattern(
                        child.get_child(0), {
                            "type": "VBoxContainer",
                            "children": [
                                {
                                    "type": "HBoxContainer",
                                    "children": [
                                        {
                                            "type": "Button",
                                        },
                                        {
                                            "type": "EditorPropertyNil",
                                        },
                                        {
                                            "type": "Button",
                                        },
                                    ]
                                }
                            ]
                        }
                    )
                    for item_child in vbox.get_children():
                        ## the grab (hamburgur) button
                        var hamburgur_toggle_button: Button = find_node_by_pattern(
                            item_child, {
                                "type": "Button"
                            }
                        )
                        hamburgur_toggle_button.text = ''
                        # hamburgur_toggle_button.icon = null
                        hamburgur_toggle_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
                        override_styleboxes(hamburgur_toggle_button, transparent_style_all)

                        ## the delete button
                        delete_button = find_node_by_pattern_bottom_up(
                            item_child, {
                                "type": "Button"
                            }
                        )
                        delete_button.add_theme_stylebox_override("normal", button_style_danger_normal)
                        delete_button.add_theme_stylebox_override("hover", button_style_danger_hover)

                        ## the drop down button
                        var drop_down_button = find_node_by_pattern_bottom_up(
                            item_child, {
                                "type": "EditorResourcePicker",
                                "children": [
                                    {
                                        "type": "Button",
                                        "children": [
                                            {
                                                "type": "TextureRect",
                                            },
                                        ],
                                    },
                                    {
                                        "type": "Button",
                                    },
                                ]
                            }
                        )
                        if drop_down_button:
                            override_styleboxes(drop_down_button.get_child(-1), transparent_style_all)
                            delete_button.reparent(drop_down_button)
                    
                    ## handle future elements
                    if not add_element_button.pressed.is_connected(_on_add_element_pressed):
                        add_element_button.pressed.connect(_on_add_element_pressed.bind(vbox, child))
                main.call_deferred()
        )

func _on_add_element_pressed(vbox: Node, child: Node):
    var new_item
    new_item = find_node_by_pattern(
        vbox, {
            "type": "EditorPropertyNil"
        }
    ).get_parent()
    new_item = vbox.get_children()[new_item.get_index() - 1] # last item is the new one actually
    
    var drop_down_button = find_node_by_pattern_bottom_up(
        new_item, {
            "type": "EditorResourcePicker",
            "children": [
                {
                    "type": "Button",
                    "children": [
                        {
                            "type": "TextureRect",
                        },
                    ],
                },
                {
                    "type": "Button",
                },
            ]
        }
    )
    override_styleboxes(drop_down_button.get_child(-1), transparent_style_all)
    var delete_button = find_node_by_pattern_bottom_up(
        new_item, {
            "type": "Button"
        }
    )
    delete_button.add_theme_stylebox_override("normal", button_style_danger_normal)
    delete_button.add_theme_stylebox_override("hover", button_style_danger_hover)
    delete_button.reparent(drop_down_button)

func override_styleboxes(node: Node, style_box: StyleBox) -> void:
    node.add_theme_stylebox_override("normal", style_box)
    node.add_theme_stylebox_override("hover", style_box)
    node.add_theme_stylebox_override("pressed", style_box)
    node.add_theme_stylebox_override("focus", style_box)

## pattern finder functions - start - generated with ai

static func _get_trimmed_node_name(node_instance_name: StringName) -> String:
    var name_str: String = str(node_instance_name)

    if name_str.begins_with("@"):
        var first_at_pos = 0
        var second_at_pos = name_str.find("@", first_at_pos + 1)

        if second_at_pos != -1: # e.g. @Type@Id
            return name_str.substr(first_at_pos + 1, second_at_pos - (first_at_pos + 1))
        else: # e.g. @Type123 or @Type
            var base_name_part = name_str.substr(first_at_pos + 1)
            var trimmed_name = ""
            for i in range(base_name_part.length()):
                if base_name_part[i].is_digit():
                    if i == 0: # Starts with digit immediately after "@", e.g., "@123Node"
                        return base_name_part # Treat as is, type likely includes numbers
                    break # Stop at first digit if not at the beginning
                trimmed_name += base_name_part[i]
            # If trimmed_name is empty, it means base_name_part was all digits (e.g. "@123")
            # or empty after "@". In this case, return base_name_part.
            return trimmed_name if not trimmed_name.is_empty() else base_name_part
    return name_str

static func _node_matches_pattern_recursive(node: Node, pattern_item: Dictionary) -> bool:
    if not is_instance_valid(node):
        return false

    var required_type: String = pattern_item.get("type", "")
    if required_type.is_empty():
        printerr("Pattern item is missing 'type' field: ", pattern_item)
        return false

    var actual_node_trimmed_name = _get_trimmed_node_name(node.name)
    
    if actual_node_trimmed_name != required_type:
        return false

    if pattern_item.has("children"):
        var required_child_patterns: Array = pattern_item.get("children")
        if not required_child_patterns is Array:
            printerr("Pattern item 'children' field must be an Array. Node: '", node.name, "', Pattern: ", pattern_item)
            return false

        # Handle "must_have_no_children" specifically if pattern_item.children is empty
        if required_child_patterns.is_empty() and pattern_item.get("must_have_no_children", false):
            if node.get_child_count() > 0:
                return false
        elif not required_child_patterns.is_empty(): # Only proceed if there are child patterns to check
            for child_pattern_item in required_child_patterns:
                if not child_pattern_item is Dictionary:
                    printerr("Child pattern item must be a Dictionary. Node: '", node.name, "', Child pattern: ", child_pattern_item)
                    return false # Malformed child pattern means parent pattern cannot match

                var found_matching_actual_child = false
                for actual_child_node in node.get_children():
                    if _node_matches_pattern_recursive(actual_child_node, child_pattern_item):
                        found_matching_actual_child = true
                        break
                
                if not found_matching_actual_child:
                    return false # One of the required child patterns was not satisfied
    
    return true

static func find_node_by_pattern(start_node: Node, root_pattern: Dictionary, search_recursively: bool = true) -> Node:
    if not is_instance_valid(start_node) or not root_pattern is Dictionary or root_pattern.is_empty():
        printerr("Invalid arguments for find_node_by_pattern.")
        return null

    if not search_recursively:
        # Only search direct children of start_node
        for child_node in start_node.get_children():
            if _node_matches_pattern_recursive(child_node, root_pattern):
                return child_node # Return first direct child that matches
        return null # No direct child matched
    else:
        # Recursive search (BFS, top-down), including start_node itself
        var queue: Array[Node] = [start_node] # Start BFS with start_node
        var visited_nodes: Array[Node] = [] # To handle potential graph-like structures, though rare for scene trees

        while not queue.is_empty():
            var current_node: Node = queue.pop_front()

            if current_node in visited_nodes: # Avoid re-processing
                continue
            visited_nodes.append(current_node)
            
            if _node_matches_pattern_recursive(current_node, root_pattern):
                return current_node # Found it

            for child_node in current_node.get_children():
                # Add to queue if not already visited or planned to be visited.
                # Simple append is usually fine for trees, but this is safer.
                if not child_node in visited_nodes: # Strictly, also check if not already in queue for non-tree graphs
                    queue.append(child_node)
        return null # No node matched

static func _find_node_by_pattern_bottom_up_recursive_helper(current_node: Node, pattern: Dictionary) -> Node:
    if not is_instance_valid(current_node):
        return null

    # 1. Search in children first (post-order traversal for deepest match)
    # Iterate children in reverse order so if multiple sibling branches have matches,
    # the one attached to a "later" child is found. This is arbitrary but consistent.
    var children = current_node.get_children()
    for i in range(children.size() - 1, -1, -1):
        var child_node = children[i]
        var found_in_child = _find_node_by_pattern_bottom_up_recursive_helper(child_node, pattern)
        if is_instance_valid(found_in_child):
            return found_in_child # Propagate match from deeper level

    # 2. If no match in children, check current_node itself
    if _node_matches_pattern_recursive(current_node, pattern):
        return current_node
    
    return null

static func find_node_by_pattern_bottom_up(start_node: Node, root_pattern: Dictionary, search_recursively: bool = true) -> Node:
    if not is_instance_valid(start_node) or not root_pattern is Dictionary or root_pattern.is_empty():
        printerr("Invalid arguments for find_node_by_pattern_bottom_up.")
        return null

    if not search_recursively:
        # Non-recursive: only check direct children of start_node.
        # "Bottom-up" for a flat list is less defined.
        # We'll return the first match found among direct children when iterating them from last to first.
        var children = start_node.get_children()
        for i in range(children.size() - 1, -1, -1): # Iterate from last child to first
            var child_node = children[i]
            if _node_matches_pattern_recursive(child_node, root_pattern):
                return child_node # Return first match encountered (which is the child with highest index)
        return null
    else:
        # Recursive bottom-up: Call helper on start_node.
        # The helper will search children of start_node first, then start_node itself, recursively.
        return _find_node_by_pattern_bottom_up_recursive_helper(start_node, root_pattern)

## pattern finder functions - end

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
