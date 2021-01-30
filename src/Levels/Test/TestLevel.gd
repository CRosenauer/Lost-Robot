extends Node2D

export var VelocityScale = 200
export var SpeedModConstraint = 250

func _process(_delta):
	$CameraComponent.position    = $World/IEntity.position * 0.7
	
	var mod = $World/IEntity.m_velocity.x * VelocityScale
	
	if(mod > SpeedModConstraint):
		mod = SpeedModConstraint
	elif(mod < -SpeedModConstraint):
		mod = -SpeedModConstraint
		
	#$CameraComponent.position.x += mod


func _on_Timer_timeout():
	$World/IEntity._on_HitBoxComponent_area_entered(null)
