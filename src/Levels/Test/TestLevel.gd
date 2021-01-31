extends Node2D

export var VelocityScale = 200
export var SpeedModConstraint = 250

func _ready():
	$Systems/CheckpointSystem.SetCheckPoint($World/IEntity.position)

func _process(_delta):
	$CameraComponent.position    = $World/IEntity.position
	
	#var mod = $World/IEntity.m_velocity.x * VelocityScale
	
	var mod = $World/IEntity.GetDirection() * VelocityScale
	
	#if(mod > SpeedModConstraint):
	#	mod = SpeedModConstraint
	#elif(mod < -SpeedModConstraint):
	#	mod = -SpeedModConstraint
	
	$CameraComponent.position.x += mod
	
	#Give player position to enemies
	if($World/Level.has_node("Enemies")):
		for i in $World/Level/Enemies.get_children():
			i.RecievePlayerPosition($World/IEntity.global_position)


func _on_Timer_timeout():
	$World/IEntity.position = $Systems/CheckpointSystem.GetCheckpoint()
	$World/IEntity.GainLife(3)
	$World/IEntity/Components/AnimatedComponent.visible = true
	$World/IEntity/Components/HitBoxComponent/HitBoxShape.disabled = false


func _on_IEntity_OnDeath():
	$RespawnTimer.start()

func _on_powerUpUnlocked(ability):
	pass


func _on_IEntity_OnLifeChanged(m_currentLife):
	$Hud/LifeBar.SetLife(m_currentLife)
