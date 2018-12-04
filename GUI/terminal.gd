extends Control

onready var LABEL = $panel/container/label

func console(text):
	LABEL.text = text
	