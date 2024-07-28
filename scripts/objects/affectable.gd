extends RigidBody3D
class_name Affectable

var gravity_effect_counter: int = 0

func addGravityEffect():
	gravity_effect_counter += 1
	gravity_scale = -1
	
func removeGravityEffect():
	if gravity_effect_counter > 0:
		gravity_effect_counter -= 1
		if gravity_effect_counter == 0:
			gravity_scale = 1
