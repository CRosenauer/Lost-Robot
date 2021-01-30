extends "res://Entity/Base/IComponent.gd"

var m_currentAudio = ""
var m_loop = false

func _ready():
	for i in get_children():
		i.connect("finished", self, "_on_AudioStreamPlayer_finished")

func PlayAudio(audio, loop):
	StopAudio()
	
	m_currentAudio = audio
	m_loop = loop
	
	if(has_node(m_currentAudio)):
		get_node(m_currentAudio).play()


func _on_AudioStreamPlayer_finished():
	if(m_loop):
		PlayAudio(m_currentAudio, m_loop)


func StopAudio():
	for i in get_children():
		i.stop()
