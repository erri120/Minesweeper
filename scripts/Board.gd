extends TileMap

export (int) var board_width = 10
export (int) var board_height = 10

var matrix=[]
var lost = false

func _ready():
	lost = false
	board_width = global.width
	board_height = global.height
	for i in range(-(board_width/2),board_width/2):
		matrix.append([])
		matrix[i+(board_width/2)] = []
		for j in range(-(board_height/2), board_height/2):
			set_cell(i,j,0,false,false)
			randomize()
			var rand = randi()%2+0
			matrix[i+(board_width/2)].append([])
			matrix[i+(board_width/2)][j+(board_height/2)] = rand

func _input(event):
	if event is InputEventMouseButton && !lost:
		if (event.is_action_pressed("p_click")):
			var event_pos = event.global_position
			var cell_pos = world_to_map(event_pos)
			cell_pos.x = cell_pos.x-16
			cell_pos.y = cell_pos.y-9
			if(cell_pos.x+(board_width/2)<board_width && cell_pos.y+(board_height/2)<board_height \
			&& cell_pos.x+board_width>board_width/2 && cell_pos.y+board_height>board_height/2):
				if(matrix[cell_pos.x+(board_width/2)][cell_pos.y+(board_height/2)] == 0):
					set_cellv(cell_pos,3,false,false)
				else:
					#GAME LOST
					set_cellv(cell_pos,1,false,false)
					lost = true
					for i in get_tree().get_nodes_in_group("Control"):
						i.show()