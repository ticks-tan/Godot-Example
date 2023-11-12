extends Node2D

const enemy_snake = preload("res://sanke/enemy_snake.gd")
const normal_snake = preload("res://sanke/normal_snake.gd");

## TileMap
@onready var bg_map: TileMap = $CanvasLayer/Control/SubViewportContainer/SubViewport/GameMap.get_node("BgMap");
## Timer
@onready var game_timer: Timer = $GameTimer
## Game Over UI
@onready var game_over_ui: Control = $CanvasLayer/Control/SubViewportContainer/SubViewport/GameOverUI
## Camera
@onready var camera: Camera2D = $CanvasLayer/Control/SubViewportContainer/SubViewport/Camera2D

## 当前玩家控制的蛇
@onready var snake : NormalSnake = null;
## 敌人蛇数组（不止一条）
var snake_enemies : Array[EnemySnake] = [];
## 食物坐标
var food_coord: Vector2i = Vector2i(-1, -1);
## 游戏是否结束
var is_over: bool = false;
## 距离上次吃到食物过去多少个timeout
var last_timeout_count := 0;
## 分数
var scores : int = 0;

## 鼠标第一次点击坐标
var first_mouse_pos: Vector2 = Vector2.ZERO;
## 判断滑动的最小距离
const min_move_distance : float = 50;

func _ready() -> void:
	var x : int = GlobalScript.MapSize.x / 2;
	var y : int = GlobalScript.MapSize.y / 2;
	snake = NormalSnake.new(3, bg_map, Vector2i(x, y));
	game_over_ui.visible = false;
	init_map();
	init_timer();
	crate_new_food();
	pass

# 初始化地图
func init_map() -> void:
	for x in range(GlobalScript.MapSize.x):
		for y in range(GlobalScript.MapSize.y):
			bg_map.set_cell(GlobalScript.BG_MAP_LAYER, Vector2i(x, y), GlobalScript.BG_MAP_ID, GlobalScript.ALL_MAP_COORD);
	pass

## 初始化定时器
func init_timer() -> void:
	game_timer.wait_time = 0.15;
	game_timer.start();
	pass

func _input(event: InputEvent) -> void:
	## 处理鼠标滑动，用于移动设备控制方向
	if event is InputEventMouseButton:
		var ev : InputEventMouseButton = event as InputEventMouseButton;
		if ev.is_pressed() and first_mouse_pos == Vector2.ZERO:
			first_mouse_pos = ev.global_position;
		if ev.is_released() and first_mouse_pos != Vector2.ZERO:
			var dir : Vector2 = ev.global_position - first_mouse_pos;
			first_mouse_pos = Vector2.ZERO;
			if abs(dir.x) < min_move_distance and abs(dir.y) < min_move_distance:
				return;
			var angle : float = 360 * dir.angle_to(Vector2.RIGHT) / (2*PI);
			var move_dir : Vector2i = Vector2i.ZERO;
			if angle > -45.0 and angle < 45.0:
				move_dir = Vector2i.RIGHT;
			elif angle > 45.0 and angle < 135.0:
				move_dir = Vector2i.UP;
			elif angle > 135.0 and angle < 225.0:
				move_dir = Vector2i.LEFT;
			elif angle >= -180.0 and angle < -135.0:
				move_dir = Vector2i.LEFT;
			elif angle > -135.0 and angle < -45.0:
				move_dir = Vector2i.DOWN;
			snake.set_direction(move_dir);
	pass

func _process(_delta: float) -> void:
	process_input();
	pass

## 处理输入
func process_input() -> void:
	if !is_over:
		if Input.is_action_pressed('ui_up') or Input.is_action_pressed("key_up"):
			snake.set_direction(Vector2i.UP);
		if Input.is_action_pressed('ui_down') or Input.is_action_pressed("key_down"):
			snake.set_direction(Vector2i.DOWN);
		if Input.is_action_pressed('ui_left') or Input.is_action_pressed("key_left"):
			snake.set_direction(Vector2i.LEFT);
		if Input.is_action_pressed('ui_right') or Input.is_action_pressed("key_right"):
			snake.set_direction(Vector2i.RIGHT);
	pass

## 抖动屏幕
func shake_screen() -> void:
	var old_pos : Vector2 = camera.get_position();
	var offsets : Array = [Vector2(60, 0), Vector2(-40, 0), Vector2(0, 80), Vector2(0, -60)];
	for offset in offsets:
		var new_pos : Vector2 = old_pos;
		new_pos += offset;
		camera.set_position(new_pos);
		await get_tree().create_timer(0.025).timeout
	camera.set_position(old_pos)
	pass

## 背景音乐降频
func down_bg_music() -> void:
	var step : float = $BgMusic.pitch_scale / 33.0;
	for i in range(30):
		if self == null:
			return;
		$BgMusic.pitch_scale -= step;
		await get_tree().create_timer(0.1).timeout
	$BgMusic.pitch_scale = 1;
	pass

## 游戏结束逻辑
func game_over() -> void:
	is_over = true;
	down_bg_music();
	await shake_screen();
	(game_over_ui.get_node("ScoresLabel") as Label).text = "Scores  " + str(scores);
	game_over_ui.visible = true;
	pass

## 重新开始游戏
func restart_game() -> void:
	## 清除蛇
	snake_enemies.clear();
	## 清除map内对象
	bg_map.clear();
	## 开始新游戏
	var x : int = GlobalScript.MapSize.x / 2;
	var y : int = GlobalScript.MapSize.y / 2;
	snake = NormalSnake.new(3, bg_map, Vector2i(x, y));
	game_over_ui.visible = false;
	init_map();
	crate_new_food();
	last_timeout_count = 0;
	game_timer.wait_time = 0.15;
	scores = 0;
	is_over = false;
	$BgMusic.play(0);
	pass

## 返回首页
func return_homepage() -> void:
	pass

## 移动敌人蛇数组内所有蛇
func move_snake_enemines() -> void:
	for enemy in snake_enemies:
		enemy.move();
	pass

## 添加新的敌人蛇
func crate_new_enemy_snake() -> void:
	# 距离上次吃到食物过去的时间不足以上一条敌人蛇走完，取消生成新的蛇
	if (last_timeout_count <= snake.get_length()):
		last_timeout_count = 0;
		return;
	last_timeout_count = 0;
	var enemy : EnemySnake = EnemySnake.new(snake.get_length(), bg_map, snake.get_history_nodes());
	snake_enemies.push_back(enemy);
	pass

## 产生新的食物
func crate_new_food() -> void:
	var randGen = RandomNumberGenerator.new();
	var vec : Vector2i = Vector2i.ZERO;
	while true:
		var x = randGen.randi_range(0, GlobalScript.MapSize.x - 1);
		var y = randGen.randi_range(0, GlobalScript.MapSize.y - 1);
		vec = Vector2i(x, y);
		if (!bg_map.get_used_cells(GlobalScript.SNAKE_MAP_LAYER).has(vec) && !bg_map.get_used_cells(GlobalScript.ENEMY_SNAKE_MAP_LAYER).has(vec)):
			break;
	food_coord = vec;
	bg_map.set_cell(GlobalScript.FOOD_LAYER, food_coord, GlobalScript.FOOD_MAP_ID, GlobalScript.ALL_MAP_COORD);
	pass

## 游戏定时器超时
func _on_game_timer_timeout() -> void:
	move_snake_enemines();
	last_timeout_count += 1;
	if !is_over:
		snake.move();
		if (snake.check_eat_food(food_coord)):
			$EtaMusic.play(0);
			$BgMusic.pitch_scale += 0.01;
			game_timer.wait_time -= 0.005;
			scores += 1;
			crate_new_food();
			crate_new_enemy_snake();
		if (snake.check_eat_self() || snake.check_eat_enemy()):
			$DieMusic.play(0);
			game_over();
	pass # Replace with function body.

func _on_retart_game_btn_pressed() -> void:
	restart_game();
	pass # Replace with function body.


func _on_return_home_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/home_page.tscn");
	pass # Replace with function body.


func _on_bg_music_finished() -> void:
	$BgMusic.play(0);
	pass # Replace with function body.
