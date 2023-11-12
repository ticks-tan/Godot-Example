class_name EnemySnake

## 路径
var path : Array[Vector2i] = [];
## 路径索引
var path_pos := 0;
## 蛇节点
var snake_node : Array[Vector2i] = [];
## 蛇长度
var snake_length := 1;
## TileMap
var map: TileMap = null;

func _init(init_length: int, map1: TileMap, his_node: Array[Vector2i]) -> void:
	snake_length = init_length - 1;
	map = map1;
	path = his_node;
	if !his_node.is_empty():
		var init_node = his_node.front();
		snake_node.push_back(init_node);
		draw_snake_node(init_node, true);
	pass

## 蛇移动
func move() -> void:
	if path.is_empty():
		return
	path_pos += 1;
	path_pos %= path.size();
	if (path_pos < path.size()):
		var next_node : Vector2i = path[path_pos];
		snake_node.push_front(next_node);
		draw_snake_node(next_node, true);
	if (snake_length > 0):
		snake_length -= 1;
	else:
		var del_node : Vector2i = snake_node.pop_back();
		draw_snake_node(del_node, false);
	pass

# 绘制蛇节点
func draw_snake_node(node: Vector2i, show: bool):
	if show:
		map.set_cell(GlobalScript.ENEMY_SNAKE_MAP_LAYER, node, GlobalScript.ENEMY_SNAKE_MAP_ID, GlobalScript.ALL_MAP_COORD);
	else:
		map.erase_cell(GlobalScript.ENEMY_SNAKE_MAP_LAYER, node);
	pass


