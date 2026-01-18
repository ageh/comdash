enum Shape
{
	Rectangle,
	Circle
}

class GameObject
{
	protected PVector position;
	protected PVector velocity;
	protected float width;
	protected float height;
	
	private PShape s;
	
	GameObject(PVector position, PVector velocity, float width, float height, Shape kind, PImage texture)
	{
		this.position = position;
		this.velocity = velocity;
		this.width = width;
		this.height = height;
		
		if (kind == Shape.Rectangle)
		{
			this.s = createShape(RECT, position.x, position.y, width, height);
		}
		else
		{
			this.s = createShape(ELLIPSE, position.x, position.y, width, height);
		}
		
		this.s.setTexture(texture);
	}
	
	void display()
	{
		shape(s);
	}
	
	void move_by(float delta_x, float delta_y)
	{
		this.position.x += delta_x;
		this.position.y += delta_y;
		this.s.translate(delta_x, delta_y);
	}
	
	void update()
	{
		this.move_by(this.velocity.x, this.velocity.y);
	}
	
	void set_x(float x)
	{
		float delta = x - this.position.x;
		this.position.x = x;
		this.s.translate(delta, 0);
	}
	
	void set_y(float y)
	{
		float delta = y - this.position.y;
		this.position.y = y;
		this.s.translate(0, delta);
	}
	
	void set_position(PVector position)
	{
		PVector delta = PVector.sub(position, this.position);
		this.position = position;
		this.s.translate(delta.x, delta.y);
	}
	
	float left()
	{
		return this.position.x;
	}
	
	float right()
	{
		return this.position.x + this.width;
	}
	
	float top()
	{
		return this.position.y;
	}
	
	float bottom()
	{
		return this.position.y + this.height;
	}
	
	boolean is_left_of_camera(float camera_x)
	{
		return this.right() < camera_x;
	}
	
	boolean is_not_visible(PVector camera_position, float screen_width, float screen_height)
	{
		return (this.right() < camera_position.x || this.left() > camera_position.x + screen_width || this.bottom() < camera_position.y || this.top() > camera_position.y + screen_height);
	}
	
	boolean collides_with(GameObject other)
	{
		return (this.right() > other.left() && this.left() < other.right() && this.bottom() > other.top() && this.top() < other.bottom());
	}
}

GameObject make_static_rectangle(PVector position, float width, float height, PImage texture)
{
	return new GameObject(position, new PVector(0, 0), width, height, Shape.Rectangle, texture);
}
