extends KinematicBody2D


func GetEntity():
	return self

func GetComponents():
	return $Components.get_children()

func GetPuppet():
	pass

func SetDirection(direction):
	if( direction != 0 && sign( direction ) != sign( cos( rotation_degrees * PI / 180 ) ) ):
		set_scale( Vector2(-1, scale.y) )
		#if(has_node("Components")):
			#if($Components.has_node("CameraComponent")):
				#$Components/CameraComponent.rotation_degrees = 0
				#$Components/CameraComponent.scale = Vector2(1, 1)

func GetDirection():
	return sign( cos( rotation_degrees * PI / 180 ) ) 
