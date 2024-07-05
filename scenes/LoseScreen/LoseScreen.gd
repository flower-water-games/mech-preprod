extends "res://addons/maaacks_game_template/extras/scenes/LoseScreen/LoseScreen.gd"

func _on_restart_button_pressed():
	SceneLoader.reload_current_scene()
	Spawning.reset()
	InGameMenuController.close_menu()

func _on_confirm_main_menu_confirmed():
	SceneLoader.load_scene(main_menu_scene)
	InGameMenuController.close_menu()
	Spawning.reset()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)