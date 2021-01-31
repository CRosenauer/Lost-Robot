extends TileMap


signal PowerUpUnlocked(ability)


func _on_WallJump_PowerUpUnlocked(ability):
	emit_signal("PowerUpUnlocked", ability)
