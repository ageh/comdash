import java.util.HashSet;

class InputManager
{
	private HashSet<Integer> key_down = new HashSet();
	private HashSet<Integer> key_pressed = new HashSet();
	private HashSet<Integer> key_released = new HashSet();
	private HashSet<Integer> key_pressed_buffer  = new HashSet();
	private HashSet<Integer> key_released_buffer = new HashSet();
	
	private HashSet<Integer> mouse_down = new HashSet();
	private HashSet<Integer> mouse_pressed = new HashSet();
	private HashSet<Integer> mouse_released = new HashSet();
	private int mouse_wheel_delta = 0;

	void reset_for_frame()
	{
		this.key_pressed.clear();
		this.key_released.clear();
		
		this.key_pressed.addAll(this.key_pressed_buffer);
		this.key_released.addAll(this.key_released_buffer);
		
		this.key_pressed_buffer.clear();
		this.key_released_buffer.clear();
		
		this.mouse_pressed.clear();
		this.mouse_released.clear();
		this.mouse_wheel_delta = 0;
	}

	void on_key_pressed(int key_code, char key_char)
	{
		int k = normalize_key(key_code, key_char);
		if (!this.key_down.contains(k))
		{
			this.key_pressed_buffer.add(k);
		}
		
		this.key_down.add(k);
	}

	void on_key_released(int key_code, char key_char)
	{
		int k = normalize_key(key_code, key_char);
		this.key_down.remove(k);
		this.key_released_buffer.add(k);
	}

	boolean is_key_down(int k)
	{
		return this.key_down.contains(k);
	}
	
	boolean was_key_pressed(int k)
	{
		return this.key_pressed.contains(k);
	}
	
	boolean was_key_released(int k)
	{
		return this.key_released.contains(k);
	}
	
	boolean is_key_down(char c)
	{
		return this.is_key_down((int) Character.toUpperCase(c));
	}
	
	boolean was_key_pressed(char c)
	{
		return this.was_key_pressed((int) Character.toUpperCase(c));
	}

	void on_mouse_button_pressed(int button)
	{
		if (!this.mouse_down.contains(button))
		{
			this.mouse_pressed.add(button);
		}
		this.mouse_down.add(button);
	}

	void on_mouse_button_released(int button)
	{
		this.mouse_down.remove(button);
		this.mouse_released.add(button);
	}

	boolean is_mouse_button_down(int button)
	{
		return this.mouse_down.contains(button);
	}
	
	boolean was_mouse_button_pressed(int button)
	{
		return this.mouse_pressed.contains(button);
	}
	
	boolean was_mouse_button_released(int button)
	{
		return this.mouse_released.contains(button);
	}

	void on_mouse_wheel_moved(int amount)
	{
		this.mouse_wheel_delta += amount;
	}
	
	int get_mouse_wheel_delta()
	{
		return this.mouse_wheel_delta;
	}
	
	private int normalize_key(int key_code, char key_char)
	{
		if (key_char != CODED)
		{
			return Character.toUpperCase(key_char);
		}
		
		return key_code;
	}
}
