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

		// Dash: press 'D' to dash; hold 'A' to dash left
		if (this.input_manager.was_key_pressed('D'))
		{
			float dir = this.input_manager.is_key_down('A') ? -1 : 1;
			this.player.dash(dir);
		}
	}
	
	void update()
	{
		this.handle_input();
		
		var obstacles = this.create_obstacles();
		this.player.update(obstacles);
		this.camera_position.x += this.scroll_speed;

		// If the player is dashing, nudge the camera forward toward the player's X
		if (this.player.isCurrentlyDashing())
		{
			float targetX = this.player.left() - 150; // keep player a bit from left edge
			if (targetX > this.camera_position.x)
			{
				this.camera_position.x = lerp(this.camera_position.x, targetX, 0.25);
			}
		}

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
			PImage bg = this.texture_manager.get("background");
			
			if (bg != null) {
				// 1. Horizontal Scroll (Parallax)
				int srcX = 200;  
				// Zooming in means taking a smaller crop from the original image width
				int cropWidth = 700;   // Decreased from 900 to "zoom in" more horizontally
				int cropHeight = 350;  // Decreased from 500 to "zoom in" more vertically
				
				float dynamicSrcX = (srcX + (this.camera_position.x * 0.1f)) % (bg.width - cropWidth);

				// 2. Vertical Alignment to Ground
				float groundScreenY = this.bedrock_level - this.camera_position.y;
				
				// 3. ZOOM & STRETCH FIX:
				// Set the background's rendering Y position to 0 (the top of the screen)
				// Then calculate how tall it needs to be to reach from the top of the window (0) down to the ground line!
				float bgY = 0;
				float bgHeight = groundScreenY; // This automatically scales it vertically to cover the black bar

				// 4. Draw it stretched to fill from the absolute top of the screen down to the ground
				image(bg, 0, bgY, width, bgHeight, (int)dynamicSrcX, 0, (int)dynamicSrcX + cropWidth, cropHeight);
			} else {
				background(135, 206, 235); 
			}

			// --- YOUR EXISTING CAMERA MATRIX CODE ---
			pushMatrix();
			// small camera shake during dash
		float shakeX = 0;
		float shakeY = 0;
		if (this.player.isCurrentlyDashing())
		{
			float p = this.player.getDashProgress();
			float s = sin(p * PI); // peak in middle of dash
			float maxShake = 8; // pixels
			float mag = s * maxShake;
			shakeX = random(-mag, mag);
			shakeY = random(-mag*0.5, mag*0.5);
		}
		translate(-this.camera_position.x - shakeX, -this.camera_position.y - shakeY);

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
