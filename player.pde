
class TrailParticle
{
	PVector position;
	float size;
	float life;
	float max_life;
	
	TrailParticle(PVector position)
	{
		this.position = position.copy();
		this.size = random(12, 18);
		this.max_life = 20;
		this.life = this.max_life;
	}
	
	void update()
	{
		this.position.x -= 0.8;
		this.position.y += random(-0.25, 0.25);
		this.life -= 1;
	}
	
	boolean is_dead()
	{
		return this.life <= 0;
	}
	
	void display()
	{
		pushStyle();
		noStroke();
		float alpha = map(this.life, 0, this.max_life, 0, 180);
		fill(255, 140, 0, alpha);
		ellipse(this.position.x, this.position.y, this.size, this.size * 0.6);
		popStyle();
	}
}

class Player extends GameObject
{
	private boolean inAir = false;
	private int jumpsUsed = 0;
	private final int MAX_JUMPS = 2;
	private ArrayList<TrailParticle> trail = new ArrayList();
	
	Player(PVector position, PVector velocity, PImage texture)
	{
		super(position, velocity, 50, 100, Shape.Rectangle, texture);
	}
	
	
	void update(ArrayList<GameObject> rest_of_the_world)
	{
		this.velocity.y += 2;
		
		this.spawn_trail();
		this.update_trail();

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
					this.jumpsUsed = 0;
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
		if (this.jumpsUsed < this.MAX_JUMPS)
		{
			this.velocity.y = -42;
			this.inAir = true;
			this.jumpsUsed++;
		}
	}

	void spawn_trail()
	{
		this.trail.add(new TrailParticle(new PVector(this.position.x - 10, this.position.y + this.height * 0.75)));
		if (this.trail.size() > 80)
		{
			this.trail.remove(0);
		}
	}

	void update_trail()
	{
		for (int i = this.trail.size() - 1; i >= 0; i--)
		{
			TrailParticle particle = this.trail.get(i);
			particle.update();
			if (particle.is_dead())
			{
				this.trail.remove(i);
			}
		}
	}

	void display()
	{
		for (TrailParticle particle : this.trail)
		{
			particle.display();
		}
		
		super.display();
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
