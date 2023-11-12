class_name NormalSnake

# 当前蛇节点
var snake_node: Array[Vector2i] = [];
# 蛇走过节点
var history_node: Array[Vector2i] = [];
"""
蛇长度, 不同于常规长度，长度大于0则每次移动后会多出一格
等于0则长度不变
"""
var snake_length : int = 0;
# 蛇运动方向
var direction : Vector2i = Vector2i.RIGHT;
# map
var map: TileMap = null;

"""
初始化蛇
init_length: 初始长度 >= 1
map: 蛇绘制的TileMap
init_node: 初始节点在TileMap中位置
"""
func _init(init_length: int, map1: TileMap, init_node: Vector2i) -> void:
	snake_length = init_length - 1;
	map = map1;
	snake_node.push_back(init_node);
	draw_snake_node(init_node, true);
	pass

# 设置蛇移动方向
func set_direction(dir: Vector2i) -> void:
	# 归一化
	if (dir != Vector2i.LEFT && dir != Vector2i.UP && dir != Vector2i.RIGHT && dir != Vector2i.DOWN):
			return;
	if direction == -dir:
		return;
	direction = dir;
	pass

# 蛇沿着指定方向移动
func move() -> void:
	if (snake_node.is_empty()):
		return
	## 判断下一个移动方向是否超出边界
	var next_head : Vector2i = snake_node.front() + direction;
	if (next_head.x < 0):
		next_head.x = GlobalScript.MapSize.x - 1;
	elif (next_head.x >= GlobalScript.MapSize.x):
		next_head.x = 0;
	elif (next_head.y < 0):
		next_head.y = GlobalScript.MapSize.y - 1;
	elif (next_head.y >= GlobalScript.MapSize.y):
		next_head.y = 0;
	# 添加到头部
	snake_node.push_front(next_head);
	# 绘制新节点
	draw_snake_node(snake_node.front(), true);
	if (snake_length > 0):
		snake_length -= 1;
	else:
		# 清除旧节点并更新历史路径
		var node: Vector2i = snake_node.pop_back();
		history_node.push_back(node);
		draw_snake_node(node, false);
		draw_history_node(node);
	pass

# 绘制蛇节点
func draw_snake_node(node: Vector2i, show: bool):
	if show:
		map.set_cell(GlobalScript.SNAKE_MAP_LAYER, node, GlobalScript.SNAKE_MAP_ID, GlobalScript.ALL_MAP_COORD);
	else:
		map.erase_cell(GlobalScript.SNAKE_MAP_LAYER, node);
	pass

# 绘制历史路径节点
func draw_history_node(node: Vector2i):
	map.set_cell(GlobalScript.HIS_MAP_LAYER, node, GlobalScript.HIS_MAP_ID, GlobalScript.ALL_MAP_COORD);
	pass

func get_history_nodes() -> Array:
	return history_node;

func get_length() -> int:
	return snake_node.size();

func check_eat_food(food: Vector2i) -> bool:
	var node : Vector2i = snake_node.front();
	var res : bool = (node == food);
	if res:
		snake_length += 1;
	return res;

func check_eat_self() -> bool:
	var i = 1;
	var head : Vector2i = snake_node.front();
	while (i < snake_node.size()):
		if (snake_node[i] == head):
			return true;
		i += 1;
	return false;

func check_eat_enemy() -> bool:
	var enemies := map.get_used_cells(GlobalScript.ENEMY_SNAKE_MAP_LAYER);
	var head : Vector2i = snake_node.front();
	return enemies.has(head);

