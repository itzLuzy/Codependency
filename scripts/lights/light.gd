extends SpotLight3D
class_name LightEffect

var forward: Vector3 = -global_transform.basis.z
var range_squared: float = spot_range ** 2

func _physics_process(delta):
	forward = -global_transform.basis.z
	for body: RigidBody3D in get_tree().get_nodes_in_group("Susceptibles"):
		var distance_squared = global_position.distance_squared_to(body.global_position)
		if distance_squared <= range_squared:
			var to_body: Vector3 = global_position.direction_to(body.global_position)
			var angle = rad_to_deg(forward.angle_to(to_body))
			if angle <= spot_angle:
				body.gravity_scale = -1
			else:
				body.gravity_scale = 1
		else:
			body.gravity_scale = 1
