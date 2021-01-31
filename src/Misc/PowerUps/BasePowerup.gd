extends Node2D

const ABILITIES = preload("res://Entity/StateMachine/LockedInputs.gd")

signal PowerUpUnlocked(ability)

export var m_powerup = ABILITIES.DoubleJump



func _on_Area2D_body_entered(body):
	$Area2D/CollisionShape2D.disabled = true
	$Sprite.visible = false
	emit_signal("PowerUpUnlocked", m_powerup)
