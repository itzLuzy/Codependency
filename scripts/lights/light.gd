extends SpotLight3D
class_name LightEffect

@onready var area: Area3D = $Area3D
@onready var collision: CollisionShape3D = $Area3D/CollisionShape3D

func _ready():
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)
	
	

#var forward: Vector3 = -global_transform.basis.z
#var range_squared: float = spot_range ** 2
func _physics_process(delta):
	print(area.get_overlapping_bodies())
	if Input.is_action_just_pressed("switch"):
		visible = not visible
		collision.disabled = not collision.disabled

func on_body_entered(body: Affectable):
	body.addGravityEffect()

func on_body_exited(body: Affectable):
	body.removeGravityEffect()
