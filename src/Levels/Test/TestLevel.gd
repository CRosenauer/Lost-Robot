extends Node2D

export var VelocityScale = 200
export var SpeedModConstraint = 250

func _process(_delta):
	$CameraComponent.position    = $IEntity.position
	
	var mod = $IEntity.m_velocity.x * VelocityScale
	
	if(mod > SpeedModConstraint):
		mod = SpeedModConstraint
	elif(mod < -SpeedModConstraint):
		mod = -SpeedModConstraint
		
	#$CameraComponent.position.x += mod
