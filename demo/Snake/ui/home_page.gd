extends Node2D

const MAIN_GAME = preload("res://ui/main_game.tscn");

const btn_change_font_size : int = 20;

func quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST);
	get_tree().quit(0);
	pass

func new_game() -> void:
	var scene : PackedScene = PackedScene.new();
	var res = scene.pack(MAIN_GAME.instantiate());
	if res == OK:
		get_tree().change_scene_to_packed(scene);
	pass

func _on_start_game_button_down() -> void:
	var start_game_fsize = $Control/StartGame.get_theme_font_size("font_size");
	$Control/StartGame.add_theme_font_size_override("font_size", start_game_fsize - btn_change_font_size);
	pass # Replace with function body.


func _on_start_game_button_up() -> void:
	var start_game_fsize = $Control/StartGame.get_theme_font_size("font_size");
	$Control/StartGame.add_theme_font_size_override("font_size", start_game_fsize + btn_change_font_size);
	pass # Replace with function body.


func _on_exit_game_button_down() -> void:
	var start_game_fsize = $Control/ExitGame.get_theme_font_size("font_size");
	$Control/ExitGame.add_theme_font_size_override("font_size", start_game_fsize - btn_change_font_size);
	pass # Replace with function body.


func _on_exit_game_button_up() -> void:
	var start_game_fsize = $Control/ExitGame.get_theme_font_size("font_size");
	$Control/ExitGame.add_theme_font_size_override("font_size", start_game_fsize + btn_change_font_size);
	pass # Replace with function body.

func _on_exit_game_pressed() -> void:
	quit_game();
	pass # Replace with function body.


func _on_start_game_pressed() -> void:
	new_game();
	pass # Replace with function body.
