extends Node2D

export var VelocityScale = 200
export var SpeedModConstraint = 250

func _ready():
	$Systems/CheckpointSystem.SetCheckPoint($World/IEntity.position)

func _process(_delta):
	$CameraComponent.position    = $World/IEntity.position
	
	var mod = $World/IEntity.m_velocity.x * VelocityScale
	
	if(mod > SpeedModConstraint):
		mod = SpeedModConstraint
	elif(mod < -SpeedModConstraint):
		mod = -SpeedModConstraint
	
	#$LifeBar.global_position = $CameraComponent.global_position
	#$CameraComponent.position.x += mod


func _on_Timer_timeout():
	$World/IEntity.position = $Systems/CheckpointSystem.GetCheckPoint()
	$World/IEntity.GainLife(3)
	$World/IEntity/Components/AnimatedComponent.visible = true


func _on_IEntity_OnDeath():
	$RespawnTimer.start()
