class Cloud
{
    private PVector position;
    private float speed;
    private float scale;
    private PImage texture;
    
    Cloud(PVector position, float speed, float scale, PImage texture)
    {
        this.position = position;
        this.speed = speed;
        this.scale = scale;
        this.texture = texture;
    }
    
    void update()
    {
        this.position.x -= this.speed;
        
        float w = this.texture.width * this.scale;
        if (this.position.x + w < 0)
        {
            this.position.x = width;
        }
    }
    
    void display()
    {
        image(this.texture, this.position.x, this.position.y, this.texture.width * this.scale, this.texture.height * this.scale);
    }
}

class CloudManager
{
    private ArrayList<Cloud> clouds = new ArrayList<Cloud>();
    
    CloudManager(int count, TextureManager texture_manager)
    {
        PImage texture = texture_manager.get("cloud");
        
        for (int i = 0; i < count; i++)
        {
            float x = random(width);
            float y = random(10, height * 0.2);
            float speed = random(0.1, 0.4);
            float scale = random(0.2, 0.4);
            
            this.clouds.add(new Cloud(new PVector(x, y), speed, scale, texture));
        }
    }
    
    void update()
    {
        for (Cloud cloud : this.clouds) { cloud.update(); }
    }
    
    void display()
    {
        for (Cloud cloud : this.clouds) { cloud.display(); }
    }
}