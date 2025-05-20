@tool
extends EditorInspectorPlugin

func _init() -> void:
    var editor_tree: SceneTree = EditorInterface.get_base_control().get_tree()
    editor_tree.node_added.connect(on_editor_node_added)

func on_editor_node_added(node: Node) -> void:
    if node.get_class() == "EditorPropertyArray":
        node.child_entered_tree.connect(func(child: Node) -> void:
            if child is PanelContainer:
                var transparent_style_all: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_transparent.tres")
                var button_style_normal: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_normal.tres")
                var button_style_hover: StyleBoxFlat = load("res://addons/debloat_array/styles/da_style_button_hover.tres")

                var hide_size_label_container := func() -> void:
                    var size_label_container: Control = child.get_child(0).get_child(0)
                    size_label_container.hide()
                    
                    var add_element_button: Button = child.get_child(0).get_child(-2)
                    add_element_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
                    add_element_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
                    add_element_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
                    add_element_button.text = '+'
                    add_element_button.icon = null
                    add_element_button.add_theme_stylebox_override("normal", button_style_normal)
                    add_element_button.add_theme_stylebox_override("hover", button_style_hover)

                    for i in range(len(child.get_child(0).get_child(1).get_children())):
                        var hamburgur_toggle_button: Button = child.get_child(0).get_child(1).get_child(i).get_child(0)
                        hamburgur_toggle_button.text = ''
                        hamburgur_toggle_button.icon = null
                        override_styleboxes(hamburgur_toggle_button, transparent_style_all)

                        var delete_button: Button = child.get_child(0).get_child(1).get_child(i).get_child(-1)
                        override_styleboxes(delete_button, transparent_style_all)

                        var drop_down_button = child.get_child(0).get_child(1).get_child(i).get_child(-2).get_child(0)
                        if len(drop_down_button.get_children()):
                            override_styleboxes(drop_down_button.get_child(-1), transparent_style_all)
                hide_size_label_container.call_deferred()
        )

func override_styleboxes(node: Node, style_box: StyleBox) -> void:
    node.add_theme_stylebox_override("normal", style_box)
    node.add_theme_stylebox_override("hover", style_box)
    node.add_theme_stylebox_override("pressed", style_box)
    node.add_theme_stylebox_override("focus", style_box)

func _can_handle(object: Object) -> bool:
    return true

func _parse_end(object: Object) -> void:
    if object is Resource:
        add_custom_control(ResourceGroupHider.new())

class ResourceGroupHider:
    extends Control
    
    func _ready() -> void:
        var resource_group_container: Control = get_parent().get_child(-2)
        resource_group_container.hide()
        queue_free()