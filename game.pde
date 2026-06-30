class Game
{
	public TextureManager texture_manager;
	private InputManager input_manager;
	
	private PlatformManager platform_manager;
	private Ground ground;
	private Player player;
	private PVector camera_position;
	private float bedrock_level;
	private float scroll_speed;
	private boolean running = true;
	
	Game(InputManager input_manager, float bedrock_level, float scroll_speed)
	{
		this.texture_manager = new TextureManager();
		this.input_manager = input_manager;
		
		this.bedrock_level = bedrock_level;
		this.scroll_speed = scroll_speed;
		
		this.player = new Player(new PVector(0, bedrock_level - 201), new PVector(this.scroll_speed, 0), this.texture_manager.get("player"));
		this.ground = new Ground(bedrock_level - 100, -200, 5, this.texture_manager);
		this.platform_manager = new PlatformManager(bedrock_level - 150, bedrock_level - 600, 150, this.texture_manager);
		this.camera_position = new PVector(-150, 0);
	}
	
	ArrayList<GameObject> create_obstacles()
	{
		var result = new ArrayList<GameObject>();
		
		result.addAll(this.ground.get_tiles());
		result.addAll(this.platform_manager.get_platforms());
		
		return result;
	}
	
	void handle_input()
	{
		if (this.input_manager.was_key_pressed(' '))
		{
			this.player.jump();
		}
	}
	
	void update()
	{
		this.handle_input();
		
		var obstacles = this.create_obstacles();
		this.player.update(obstacles);
		this.camera_position.x += this.scroll_speed;
		this.camera_position.y = min(this.player.top() - 100, this.bedrock_level - height);
		
		this.ground.update(this.camera_position.x);
		this.platform_manager.update(this.camera_position.x);
		
		if (this.player.is_left_of_camera(this.camera_position.x))
		{
			this.running = false;
		}
	}
	
	void display()
	{
    image(this.texture_manager.get("background"), 0, 0, width, height);
    
    pushMatrix();
    translate(-this.camera_position.x, -this.camera_position.y);
    
    this.ground.display();
    this.platform_manager.display();
    this.player.display();
    
    popMatrix();
	}
	
	boolean is_running()
	{
		return this.running;
	}
}
