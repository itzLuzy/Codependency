extends SpotLight3D
class_name LightEffect
@onready var collision_detector = %CollisionDetector
var affected_bodies: Array = []

func _ready():
	collision_detector.body_entered.connect(on_body_entered)
	collision_detector.body_exited.connect(on_body_exited)

func _physics_process(delta):
	if Input.is_action_just_pressed("switch"):
		if light_energy > 0:
			light_energy = 0
		else:
			light_energy = 9
		
func on_body_entered(body: Affectable):
	print(body.name + ": Entered")
	body.addGravityEffect()

func on_body_exited(body: Affectable):
	print(body.name + ": Exited")
	body.removeGravityEffect()
