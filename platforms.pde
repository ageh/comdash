import java.util.ArrayDeque;

class PlatformManager
{
	private TextureManager texture_manager;
	
	private ArrayDeque<GameObject> platforms = new ArrayDeque();
	private float maximum_height;
	private float minimum_height;
	private float minimum_gap;
	private int last_fire_platform_millis = 0;

	PlatformManager(float minimum_height, float maximum_height, float minimum_gap, TextureManager texture_manager)
	{
		this.texture_manager = texture_manager;
		this.minimum_height = minimum_height;
		this.maximum_height = maximum_height;
		this.minimum_gap = minimum_gap;
	}
	
	void update(float camera_x)
	{
		float right = camera_x + width;
		
		while (!this.platforms.isEmpty() && this.platforms.peekFirst().is_left_of_camera(camera_x))
		{
			this.platforms.removeFirst();
		}
		
		if (this.platforms.isEmpty() || (!this.platforms.isEmpty() && right > this.platforms.getLast().right() + this.minimum_gap))
		{
			float spawn_chance = random(1.0);
			
			if (spawn_chance < 0.1)
			{
				float y = random(this.maximum_height, this.minimum_height);
				boolean is_fire_platform = millis() - this.last_fire_platform_millis >= 5000;
				if (is_fire_platform)
				{
					this.last_fire_platform_millis = millis();
				}
				String texture_name = is_fire_platform ? "platform-fire" : "platform-grass";
				this.platforms.add(make_static_rectangle(new PVector(right + 100, y), 181, 30, this.texture_manager.get(texture_name)));
			}
		}
	}
	
	void display()
	{
		for (GameObject p : this.platforms)
		{
			p.display();
		}
	}
	
	ArrayDeque<GameObject> get_platforms()
	{
		return this.platforms;
	}
}
