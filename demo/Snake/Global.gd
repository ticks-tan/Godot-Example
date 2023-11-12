extends Node2D

## 地图尺寸
const MapSize: Vector2i = Vector2i(50, 30);
## 视口大小
var ViewPortSize : Vector2i = Vector2i(
		ProjectSettings.get('display/window/size/viewport_width'), 
		ProjectSettings.get('display/window/size/viewport_height')
	);

## 各个元素Layer层
const BG_MAP_LAYER := 0;
const HIS_MAP_LAYER := 0;
const SNAKE_MAP_LAYER := 1;
const FOOD_LAYER := 1;
const ENEMY_SNAKE_MAP_LAYER := 2;

## 各个元素 TileSet Source ID
const BG_MAP_ID := 1;
const HIS_MAP_ID := 2;
const SNAKE_MAP_ID := 3;
const ENEMY_SNAKE_MAP_ID := 4;
const FOOD_MAP_ID := 5;

## 各个元素TileSet本地坐标
const ALL_MAP_COORD := Vector2i(0, 0);
