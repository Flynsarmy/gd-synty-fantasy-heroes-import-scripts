@tool
extends Node3D

@export var reconfigure_mesh_instances: bool = false : set = _set_reconfigure_mesh_instances

func _set_reconfigure_mesh_instances(_new_value: bool) -> void:
	var skeleton: Skeleton3D = %GeneralSkeleton
	@warning_ignore("unassigned_variable")
	var names_dict: Dictionary

	# Regex to grab a string with Chr_ prefix and number suffix stripped
	var regex = RegEx.new()
	regex.compile("^Chr_(.+)_\\d\\d$")

	# Grab all unique mesh instance parts
	for mi in skeleton.get_children():
		# Get the MI name starting after the Chr_ prefix
		var mi_name: String
		var result: RegExMatch = regex.search(mi.name)
		if result:
			# Also strip any _Female/_Male suffix
			mi_name = result.get_string(1)\
				.replace("_Female", "")\
				.replace("_Male", "")\
				.replace("Ear_Ear", "Ear")

			# Save unique name by using a dictionary key
			names_dict[mi_name] = 0
		else:
			print("Error: invalid naming convention '%s'." % mi.name)
			continue

	# Grab our list of unique names out of the dictionary
	var names: Array[String] = []
	for key in names_dict.keys():
		names.append(key as String)

	var names_count: int = names.size()

	# Delete all mesh instance children we don't need
	for child in skeleton.get_children().slice(names_count):
		# Queue_free doesn't work here.
		child.get_parent().remove_child(child)

	# Rename the remaining MIs and remove their meshes
	for i in range(names_count):
		var mi: MeshInstance3D = skeleton.get_child(i)
		mi.name = names[i]
		mi.mesh = null
