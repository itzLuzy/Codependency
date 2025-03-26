extends SubViewport
class_name CollisionDetector

@onready var main_camera: Camera3D = $"../CameraAnchorY/CameraAnchorX/Camera3D"
@onready var camera: Camera3D = $Camera
@onready var texture_rect = $"../TextureRect"
@onready var space_state: PhysicsDirectSpaceState3D = get_parent().get_world_3d().direct_space_state

var precision: float = 1.5
var affectable_bodies: Array = []

signal body_entered(body: Affectable)
signal body_exited(body: Affectable)

func average_color(texture: ViewportTexture) -> Color:
	var image = texture.get_image()
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	return image.get_pixel(0, 0)


func upscale_coords(smol_coords: Vector2i):
	var screen_size: Vector2 = get_parent().get_viewport().get_visible_rect().size
	var x = (screen_size.x - screen_size.y)/2 + smol_coords.x * (screen_size.y/32)
	var y = smol_coords.y * (screen_size.y/32)
	var coords = Vector2i(x, y)
	return coords

func _ready():
	precision = pow(2, 5 + precision)
	size = Vector2i(precision, precision)

func _physics_process(delta):
	camera.global_position = main_camera.global_position
	camera.global_rotation = main_camera.global_rotation
	var texture: ViewportTexture = get_texture()
	texture_rect.texture = texture

	var image: Image = texture.get_image()
	var width = image.get_width()
	var height = image.get_height()
	var point: Vector2i = Vector2i(-1, -1)
	var new_affectables = []
	for x in range(width):
		for y in range(height):
			if image.get_pixel(x,y).get_luminance() > 0:
				point = Vector2i(x,y)
				var ray_origin = camera.project_ray_origin(point)
				var ray_end = ray_origin + camera.project_ray_normal(point) * 100
				var args = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 0b00000110)
				var ray_dict = space_state.intersect_ray(args)
				if ray_dict.has("collider"):
					var body = ray_dict["collider"]
					if body is Affectable and not body in new_affectables:
						new_affectables.append(body)
						if not body in affectable_bodies:
							emit_signal("body_entered", body)
	for body in affectable_bodies:
		if not body in new_affectables:
			emit_signal("body_exited", body)
	affectable_bodies = new_affectables
