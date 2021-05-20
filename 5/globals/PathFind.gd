extends TileMap

class_name PathfindA

onready var astar_node = AStar.new()

export(Vector2) var map_size = Vector2(500, 500)

const Base_Line_Width = 3.0
const Draw_Color = Color('#fff')

onready var walkable_cells = get_used_cells_by_id(0)
onready var _half_cells_size = cell_size / 2

func _ready():
	var walkable_cells_list = astar_add_walkable_cells(walkable_cells)
	astar_connect_walkable_cells_diagonal(walkable_cells_list)
	hide()
	
func astar_add_walkable_cells(walkable_cells = []):
	var points_array = []
	for y in range(-map_size.y, map_size.y):
		for x in range(-map_size.x, map_size.x):
			var point = Vector2(x, y)
			if point in walkable_cells:
				points_array.append(point)
				var point_index = calculate_point_index(point)
				astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array

func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x -1, point.y + local_y -1)
				var point_relative_index = calculate_point_index(point_relative)
				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)

func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y
	
func calculate_point_index(point):
	return point.x + map_size.x * point.y

func is_valid_node(point):
	return astar_node.has_point(calculate_point_index(world_to_map(to_local(point))))
	
func get_simple_path(world_start, world_end):
	var path_start_position = world_to_map(to_local(world_start))
	var world_to_map_end:Vector2 = world_to_map(to_local(world_end))
	var closest_point_id = astar_node.get_closest_point(Vector3(world_to_map_end.x, world_to_map_end.y, 0.0))
	if closest_point_id == -1:
		return []
	var closest_point_vector3 = astar_node.get_point_position(closest_point_id)
		
	var path_end_position = Vector2(closest_point_vector3.x, closest_point_vector3.y)
	if not path_start_position in walkable_cells || not path_end_position in walkable_cells:
		return []
	if is_outside_map_bounds(path_start_position) || is_outside_map_bounds(path_end_position):
		return []
		
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	var _point_path = astar_node.get_point_paths(start_point_index, end_point_index)
	
	var path_world = []
	for point in _point_path:
		var point_world = to_global(map_to_world(Vector2(point.x, point.y)) + _half_cells_size)
		path_world.append(point_world)
	
	return path_world
	
