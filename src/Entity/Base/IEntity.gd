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

func GetDirection():
	return sign( cos( rotation_degrees * PI / 180 ) ) 
