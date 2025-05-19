@tool
extends EditorInspectorPlugin

func _init() -> void:
	var editor_tree: SceneTree = EditorInterface.get_base_control().get_tree()
	editor_tree.node_added.connect(on_editor_node_added)

func on_editor_node_added(node: Node) -> void:
	if node.get_class() == "EditorPropertyArray":
		node.child_entered_tree.connect(func(child: Node) -> void:
			if child is PanelContainer:
				var hide_size_label_container := func() -> void:
					var size_label_container: Control = child.get_child(0).get_child(0)
					size_label_container.hide()
				hide_size_label_container.call_deferred()
		)

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