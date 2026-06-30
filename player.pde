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
		
		this.move_by(this.velocity.x, 0);
		
		for (GameObject o : rest_of_the_world)
		{
			if (this.collides_with(o))
			{
				float x = this.velocity.x > 0 ? o.left() - this.width : o.right();
				this.velocity.x = 0;
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
}
