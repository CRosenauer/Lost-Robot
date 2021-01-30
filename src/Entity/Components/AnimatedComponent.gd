extends AnimatedSprite


export var defaultAnimation = ""
var m_currentAnim = ""

func _ready():
	pass

func SetAnimation(animName):
	m_currentAnim = animName
	play(animName)
	

func SetXVelocity(velocity):
	if(m_currentAnim == "Idle"):
		if(velocity != 0):
			SetAnimation("Walk")
	elif(m_currentAnim == "Walk"):
		if(velocity == 0):
			SetAnimation("Idle")
