class Player extends GameObject
{
	private boolean inAir = false;
	
	Player(PVector position, PVector velocity, PImage texture)
	{
		super(position, velocity, 50, 100, Shape.Rectangle, texture);
	}
	
	
	void update(ArrayList<GameObject> rest_of_the_world)
	{
		this.velocity.y += 2;

		float dt = frameRate > 0 ? 1.0/frameRate : 1.0/60.0;
		this.update_dash_timers(dt);

		float dx = this.get_horizontal_velocity_for_frame();

		this.move_by(dx, 0);
		
		for (GameObject o : rest_of_the_world)
		{
			if (this.collides_with(o))
			{
				float x = dx > 0 ? o.left() - this.width : o.right();
				this.velocity.x = 0;
				if (this.isDashing)
				{
					this.isDashing = false;
					this.dashCooldownTimer = this.dashCooldown;
				}
				this.set_x(x);
				break;
			}
		}
		
		this.move_by(0, this.velocity.y);
		
		this.inAir = true;
		
		for (GameObject o : rest_of_the_world)
		{
			if (this.collides_with(o))
			{
				float y;
				if (this.velocity.y > 0)
				{
					y = o.top() - this.height;
					this.inAir = false;
				}
				else
				{
					y = o.bottom();
				}
				
				this.velocity.y = 0;
				this.set_y(y);
				break;
			}
		}
	}
	
	void jump()
	{
		if (!this.inAir)
		{
			this.velocity.y = -42;
			this.inAir = true;
		}
	}

	void dash(float direction)
	{
		if (this.isDashing) return;
		if (this.dashCooldownTimer > 0) return;

		this.isDashing = true;
		this.dashTimer = 0;
		this.dashDirection = direction >= 0 ? 1 : -1;
	}

// --- Dash configuration & state (antonfeat) ---
float dashMultiplier = 4;    // 4x normal speed
float dashDuration = 0.3;    // 0.3 seconds
float dashCooldown = 3.0;    // 3 seconds cooldown

boolean isDashing = false;
float dashTimer = 0;
float dashCooldownTimer = 0;
float dashDirection = 1;

	// Update timers and apply dash movement
	void update_dash_timers(float dt)
	{
		if (this.isDashing)
		{
			this.dashTimer += dt;
			if (this.dashTimer >= this.dashDuration)
			{
				this.isDashing = false;
				this.dashCooldownTimer = this.dashCooldown;
			}
		}
		else if (this.dashCooldownTimer > 0)
		{
			this.dashCooldownTimer = max(0, this.dashCooldownTimer - dt);
		}
	}

	float get_horizontal_velocity_for_frame()
	{
		if (this.isDashing)
		{
			float base = abs(this.velocity.x) > 0 ? abs(this.velocity.x) : 5; // fallback base speed
			return this.dashDirection * base * this.dashMultiplier;
		}
		return this.velocity.x;
	}

	boolean isCurrentlyDashing()
	{
		return this.isDashing;
	}

	// Returns dash progress in [0,1]
	float getDashProgress()
	{
		if (this.dashDuration <= 0) return 0;
		return constrain(this.dashTimer / this.dashDuration, 0, 1);
	}

}
