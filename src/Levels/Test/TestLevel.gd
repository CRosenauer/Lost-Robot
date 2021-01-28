extends Node2D

func _process(_delta):
	$CameraComponent.position = $IEntity.position
