InputManager input_manager;
Game game;
void setup()
{
    size(1280, 720, P2D);
    noStroke();
    textureMode(NORMAL);
    ellipseMode(CORNER);
    
    input_manager = new InputManager();
    SoundManager sound_manager = new SoundManager(this);
    game = new Game(input_manager, sound_manager, 2000, 4.2);
}
void draw()
{
    input_manager.reset_for_frame();
    
    background(138, 244, 255);
    
    if (!game.is_running())
    {
        fill(255, 128, 0);
        textSize(96);
        textAlign(CENTER);
        text("GAME OVER", width / 2, height / 2);
        textAlign(LEFT);
        return;
    }
    
    game.update();
    game.display();
    
    drawFpsCounter();
}
void drawFpsCounter()
{
    fill(255);
    textSize(16);
    text("Frame rate: " + int(frameRate), 10, 20);
}
void keyPressed()
{
    input_manager.on_key_pressed(keyCode, key);
}
void keyReleased()
{
    input_manager.on_key_released(keyCode, key);
}
void mousePressed()
{
    input_manager.on_mouse_button_pressed(mouseButton);
}
void mouseReleased()
{
    input_manager.on_mouse_button_released(mouseButton);
}