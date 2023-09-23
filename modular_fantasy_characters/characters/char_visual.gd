@tool
extends Node3D

# Prefix all meshes were given during import
const MESH_PREFIX: String = 'visuals_'
# Directory the meshes are saved in
const MESH_SUBDIR: String = 'meshes'

@export var randomize: bool = false : set = _set_randomize
@export_group("Body Parts")
@export_range(0, 38) var arm_lower_left: int = 0: set = _set_arm_lower_left
@export_range(0, 38) var arm_lower_right: int = 0: set = _set_arm_lower_right
@export_range(0, 42) var arm_upper_left: int = 0: set = _set_arm_upper_left
@export_range(0, 42) var arm_upper_right: int = 0: set = _set_arm_upper_right
@export_range(0, 3) var ear: int = 0: set = _set_ear
@export_range(0, 36) var hand_left: int = 0: set = _set_hand_left
@export_range(0, 36) var hand_right: int = 0: set = _set_hand_right
@export_range(0, 46) var head: int = 0: set = _set_head
@export_range(0, 29) var head_no_elements: int = 0: set = _set_head_no_elements
@export_range(0, 58) var hips: int = 0: set = _set_hips
@export_range(0, 40) var leg_left: int = 0: set = _set_leg_left
@export_range(0, 40) var leg_right: int = 0: set = _set_leg_right
@export_range(0, 58) var torso: int = 0: set = _set_torso
@export_group("Hair")
@export_range(0, 17) var eyebrow: int = 0: set = _set_eyebrow
@export_range(0, 18) var facial_hair: int = 0: set = _set_facial_hair
@export_range(0, 38) var hair: int = 0: set = _set_hair
@export_group("Attachments")
@export_range(0, 15) var back_attachment: int = 0: set = _set_back_attachment
@export_range(0, 6) var elbow_attach_left: int = 0: set = _set_elbow_attach_left
@export_range(0, 6) var elbow_attach_right: int = 0: set = _set_elbow_attach_right
@export_range(0, 11) var head_coverings_base_hair: int = 0: set = _set_head_coverings_base_hair
@export_range(0, 4) var head_coverings_no_facial_hair: int = 0: set = _set_head_coverings_no_facial_hair
@export_range(0, 13) var head_coverings_no_hair: int = 0: set = _set_head_coverings_no_hair
@export_range(0, 13) var helmet_attachment: int = 0: set = _set_helmet_attachment
@export_range(0, 12) var hips_attachment: int = 0: set = _set_hips_attachment
@export_range(0, 11) var knee_attach_left: int = 0: set = _set_knee_attach_left
@export_range(0, 11) var knee_attach_right: int = 0: set = _set_knee_attach_right
@export_range(0, 21) var shoulder_attach_left: int = 0: set = _set_shoulder_attach_left
@export_range(0, 21) var shoulder_attach_right: int = 0: set = _set_shoulder_attach_right

var mesh_list: Array[String] = []
var meshes_dir: String = ""

func load_meshes() -> void:
	mesh_list = get_mesh_filenames()

func get_mesh_filenames() -> Array[String]:
	var filenames: Array[String] = []

	var dir: DirAccess = DirAccess.open(get_meshes_dir())
	if dir:
		dir.list_dir_begin()
		var filename: String = dir.get_next()
		while filename != "":
			if not dir.current_is_dir():
				filenames.append(filename)
			filename = dir.get_next()
	else:
		push_error("Meshes subdirectory not found.")

	return filenames

func get_meshes_dir() -> String:
	if meshes_dir.length() == 0:
		var path: PackedStringArray = self.get_script().get_path().split('/')
		path.resize(path.size() - 1)
		meshes_dir = "/".join(path) + "/" + MESH_SUBDIR

	return meshes_dir

func set_mesh(mi: MeshInstance3D, filter: String, num: int) -> void:
	# Meshes are set 1-based
	if num == 0:
		mi.mesh = null
		return

	# Arrays are 0-based
	num = num - 1

	if not mesh_list.size():
		load_meshes()

	var matching_meshes: Array[String]
	# Special case for 'Head' since it will accidentally also include
	# _Head_No_Elements
	if filter == "Head":
		matching_meshes = \
			mesh_list.filter(func (mesh: String): return mesh.contains("Head_Male") or mesh.contains("Head_Female"))
	else:
		matching_meshes = \
			mesh_list.filter(func (mesh: String): return mesh.contains(filter))

	if num > matching_meshes.size():
		push_error("Found '%s' meshes when matching '%s' but trying to assign number %s." % [matching_meshes.size(), filter, num])

	var mesh_filepath: String = ""
	if matching_meshes.size() > 0:
		mesh_filepath = get_meshes_dir() + "/" + matching_meshes[min(matching_meshes.size() - 1, num)]

	var new_mesh: Mesh = load(mesh_filepath)
	mi.mesh = new_mesh

func _set_randomize(new_value: bool) -> void:
	arm_lower_left = randi_range(0, 38)
	arm_lower_right = randi_range(0, 38)
	arm_upper_left = randi_range(0, 42)
	arm_upper_right = randi_range(0, 42)
	ear = randi_range(0, 3)
	hand_left = randi_range(0, 36)
	hand_right = randi_range(0, 36)
	head = randi_range(0, 46)
	head_no_elements = randi_range(0, 29)
	hips = randi_range(0, 58)
	leg_left = randi_range(0, 40)
	leg_right = randi_range(0, 40)
	torso = randi_range(0, 58)
	eyebrow = randi_range(0, 17)
	facial_hair = randi_range(0, 18)
	hair = randi_range(0, 38)
	back_attachment = randi_range(0, 15)
	elbow_attach_left = randi_range(0, 6)
	elbow_attach_right = randi_range(0, 6)
	head_coverings_base_hair = randi_range(0, 11)
	head_coverings_no_facial_hair = randi_range(0, 4)
	head_coverings_no_hair = randi_range(0, 13)
	helmet_attachment = randi_range(0, 13)
	hips_attachment = randi_range(0, 12)
	knee_attach_left = randi_range(0, 11)
	knee_attach_right = randi_range(0, 11)
	shoulder_attach_left = randi_range(0, 21)
	shoulder_attach_right = randi_range(0, 21)


func _set_arm_lower_left(new_value: int) -> void:
	arm_lower_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ArmLowerLeft, "ArmLowerLeft", new_value)


func _set_arm_lower_right(new_value: int) -> void:
	arm_lower_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ArmLowerRight, "ArmLowerRight", new_value)

func _set_arm_upper_left(new_value: int) -> void:
	arm_upper_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ArmUpperLeft, "ArmUpperLeft", new_value)

func _set_arm_upper_right(new_value: int) -> void:
	arm_upper_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ArmUpperRight, "ArmUpperRight", new_value)

func _set_back_attachment(new_value: int) -> void:
	back_attachment = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/BackAttachment, "BackAttachment", new_value)

func _set_ear(new_value: int) -> void:
	ear = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Ear, "Ear_Ear", new_value)

func _set_elbow_attach_left(new_value: int) -> void:
	elbow_attach_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ElbowAttachLeft, "ElbowAttachLeft", new_value)

func _set_elbow_attach_right(new_value: int) -> void:
	elbow_attach_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ElbowAttachRight, "ElbowAttachRight", new_value)

func _set_eyebrow(new_value: int) -> void:
	eyebrow = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Eyebrow, "Eyebrow", new_value)

func _set_hair(new_value: int) -> void:
	hair = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Hair, "_Hair_", new_value)

func _set_facial_hair(new_value: int) -> void:
	facial_hair = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/FacialHair, "FacialHair", new_value)

func _set_hand_left(new_value: int) -> void:
	hand_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HandLeft, "HandLeft", new_value)

func _set_hand_right(new_value: int) -> void:
	hand_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HandRight, "HandRight", new_value)

func _set_head(new_value: int) -> void:
	head = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Head, "Head", new_value)

func _set_head_no_elements(new_value: int) -> void:
	head_no_elements = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Head_No_Elements, "Head_No_Elements", new_value)

func _set_head_coverings_base_hair(new_value: int) -> void:
	head_coverings_base_hair = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HeadCoverings_Base_Hair, "HeadCoverings_Base_Hair", new_value)

func _set_head_coverings_no_facial_hair(new_value: int) -> void:
	head_coverings_no_facial_hair = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HeadCoverings_No_FacialHair, "HeadCoverings_No_FacialHair", new_value)

func _set_head_coverings_no_hair(new_value: int) -> void:
	head_coverings_no_hair = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HeadCoverings_No_Hair, "HeadCoverings_No_Hair", new_value)

func _set_helmet_attachment(new_value: int) -> void:
	helmet_attachment = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HelmetAttachment, "HelmetAttachment", new_value)

func _set_hips(new_value: int) -> void:
	hips = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Hips, "_Hips_", new_value)

func _set_hips_attachment(new_value: int) -> void:
	hips_attachment = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/HipsAttachment, "HipsAttachment", new_value)

func _set_knee_attach_left(new_value: int) -> void:
	knee_attach_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/KneeAttachLeft, "KneeAttachLeft", new_value)

func _set_knee_attach_right(new_value: int) -> void:
	knee_attach_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/KneeAttachRight, "KneeAttachRight", new_value)

func _set_leg_left(new_value: int) -> void:
	leg_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/LegLeft, "LegLeft", new_value)

func _set_leg_right(new_value: int) -> void:
	leg_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/LegRight, "LegRight", new_value)

func _set_shoulder_attach_left(new_value: int) -> void:
	shoulder_attach_left = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ShoulderAttachLeft, "ShoulderAttachLeft", new_value)

func _set_shoulder_attach_right(new_value: int) -> void:
	shoulder_attach_right = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/ShoulderAttachRight, "ShoulderAttachRight", new_value)

func _set_torso(new_value: int) -> void:
	torso = new_value
	if is_inside_tree():
		set_mesh(%GeneralSkeleton/Torso, "Torso", new_value)
