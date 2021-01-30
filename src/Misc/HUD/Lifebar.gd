extends Node2D


const m_maxLife = 3


func SetLife(life):
	var lifeBlocks = $LifeBlocks.get_children()
	life -= 1
	for i in range(0, m_maxLife):
		if(i <= life):
			lifeBlocks[i].visible = true
		else:
			lifeBlocks[i].visible = false
