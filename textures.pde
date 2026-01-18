import java.util.HashMap;

class TextureManager
{
	private HashMap<String, PImage> textures = new HashMap();
	
	TextureManager()
	{
		this.textures.put("player", loadImage("textures/player.png"));
		this.textures.put("grass", loadImage("textures/grass.png"));
		this.textures.put("snow", loadImage("textures/snow.png"));
		this.textures.put("platform-grass", loadImage("textures/platform-grass.png"));
		
		this.debugTextures();
	}
	
	PImage get(String key)
	{
		return textures.get(key);
	}
	
	void debugTextures()
	{
		for (String k : this.textures.keySet())
		{
			PImage img = this.textures.get(k);
			println(k + " -> " + (img == null ? "NULL" : (img.width + "x" + img.height)));
		}
	}
}
