extends StaticBody

onready var player = $"../../Player"

func InteractWith(caller: Object):
	player.emit_signal("DialogStart")
	var dialog = Dialogic.start('Test')
	dialog.connect("dialogic_signal", self, "onExit")
	get_tree().get_root().add_child(dialog)

func onExit(string: String):
	match string:
		"exit":
			player.emit_signal("DialogStop")
