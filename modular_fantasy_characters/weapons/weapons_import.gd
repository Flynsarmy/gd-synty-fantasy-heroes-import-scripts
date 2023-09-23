@tool
extends EditorScenePostImport

var path: String = ""

# This sample changes all node names.
# Called right after the scene is imported and gets the root node.
func _post_import(scene: Node) -> Object:
	path = get_source_path()

	# Change all node names to "modified_[oldnodename]"
	iterate(scene)
	return scene # Remember to return the imported scene

func iterate(node: Node) -> void:
	if node != null:
		if node is MeshInstance3D:
			# Remove the unnecessary prefix
			node.name = node.name.replace("SK_Wep_", "")

			# Save this MeshInstance to its own scene
			var packed_scene: PackedScene = PackedScene.new()
			packed_scene.pack(node)
			ResourceSaver.save(packed_scene, path + node.name + ".tscn")

		for child in node.get_children():
			iterate(child)

# Returns the absolute folder path of the file being imported with trailing /
func get_source_path() -> String:
	var path_segments: PackedStringArray = get_source_file().split("/")
	path_segments.resize(path_segments.size() - 1)
	return "/".join(path_segments) + "/"
