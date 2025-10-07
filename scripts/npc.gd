extends StaticBody

func InteractWith(caller: Object):
	caller.emit_signal("DialogStart")
	
	var dialog = Dialogic.start('Test')
	dialog.connect("dialogic_signal", self, "onExit", [caller])
	get_tree().get_root().add_child(dialog)

func onExit(string: String, caller: Object):
	match string:
		"exit":
			caller.emit_signal("DialogStop")
