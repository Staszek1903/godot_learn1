extends Node2D

func _ready() -> void:
	$GameButton.connect("state_change", $Door, "_on_button_signal")
	$spawnButton.connect("state_change", $Spawner, "_on_button_signal")
