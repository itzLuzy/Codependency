extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 8
var sensibility = 0.7
var max_camera_angle = 90
var min_camera_angle = -80
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera_anchor_y := $CameraAnchorY
@onready var camera_anchor_x = $CameraAnchorY/CameraAnchorX
@onready var camera := $CameraAnchorY/CameraAnchorX/Camera3D
@onready var r_hand = $CameraAnchorY/CameraAnchorX/RHand
@onready var l_hand = $CameraAnchorY/CameraAnchorX/LHand



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_anchor_y.rotate_y(-event.relative.x * 0.005 * sensibility)
			camera_anchor_x.rotate_x(-event.relative.y * 0.005 * sensibility)
			camera_anchor_x.rotation.x = clamp(camera_anchor_x.rotation.x, deg_to_rad(min_camera_angle), deg_to_rad(max_camera_angle))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction = (camera_anchor_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
