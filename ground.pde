class Ground
{
	private TextureManager texture_manager;
	
	private ArrayList<GameObject> tiles = new ArrayList();
	
	Ground(float ground_level, float first_x, int buffer_size, TextureManager texture_manager)
	{
		this.texture_manager = texture_manager;
		
		int tile_count = ceil(width / 100.0) + buffer_size;
		for (int i = 0; i < tile_count; ++i)
		{
			var position = new PVector(first_x + i * 100, ground_level);
			if (i == tile_count - 1)
			{
				this.tiles.add(make_static_rectangle(position, 100, 100, this.texture_manager.get("snow")));
				continue;
			}
			
			this.tiles.add(make_static_rectangle(position, 100, 100, this.texture_manager.get("grass")));
		}
	}
	
	void update(float camera_x)
	{
		int tile_count = this.tiles.size();
		for (GameObject tile : this.tiles)
		{
			if (tile.is_left_of_camera(camera_x))
			{
				tile.move_by(100 * tile_count, 0);
			}
		}
	}
	
	void display()
	{
		for (var tile : this.tiles)
		{
			tile.display();
		}
	}
	
	ArrayList<GameObject> get_tiles()
	{
		return this.tiles;
	}
}
