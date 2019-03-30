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

func tileIndex(bombs_near):
	var r = 3
	if(bombs_near == 0):
		r = 3
	if(bombs_near == 1):
		r = 4
	if(bombs_near == 2):
		r = 5
	if(bombs_near == 3):
		r = 6
	if(bombs_near == 4):
		r = 7
	if(bombs_near == 5):
		r = 8
	if(bombs_near == 6):
		r = 9
	if(bombs_near == 7):
		r = 10
	if(bombs_near == 8):
		r = 11
	return r

func bombs_near(pos):
	var bombs = 0
	for x in range(pos.x-1,pos.x+1):
		if(x>=0):
			for y in range(pos.y-1,pos.y+1):
				if(y>= 0):
					if(matrix[x][y]==1):
						bombs+=1
						print(str(x)+","+str(y)+": Bomb")
	return bombs

func change_tile(cell_pos):
	var m_pos = cell_pos
	m_pos.x = cell_pos.x+(board_width/2)
	m_pos.y = cell_pos.y+(board_height/2)
	var bombs = bombs_near(m_pos)
	set_cellv(cell_pos,tileIndex(bombs),false,false)
	if(bombs == 0):
		var nomore = false
		for x in range(cell_pos.x-1,cell_pos.x+1):
			for y in range(cell_pos.y-1,cell_pos.y+1):
				var xycell = Vector2(x,y)
				if(xycell != cell_pos):
					pass
					#change_tile(xycell)

func _input(event):
	if event is InputEventMouseButton && !lost:
		var event_pos = event.global_position
		var cell_pos = world_to_map(event_pos)
		cell_pos.x = cell_pos.x-16
		cell_pos.y = cell_pos.y-9.5
		var m_pos = cell_pos
		m_pos.x = cell_pos.x+(board_width/2)
		m_pos.y = cell_pos.y+(board_height/2)
		if(m_pos.x<board_width && m_pos.y<board_height \
		&& cell_pos.x+board_width>board_width/2 && cell_pos.y+board_height>board_height/2):
			if (event.is_action_pressed("p_click")):
				if(matrix[m_pos.x][m_pos.y] == 0):
					#print("Pos: "+str(m_pos))
					if(m_pos.x == 0):
						pass
					if(m_pos.y == 0):
						pass
					change_tile(cell_pos)
				else:
					#GAME LOST
					set_cellv(cell_pos,1,false,false)
					lost = true
					for i in get_tree().get_nodes_in_group("Control"):
						i.show()
			if (event.is_action_pressed("p_flag") && global.allow_flags):
				set_cellv(cell_pos,2,false,false)