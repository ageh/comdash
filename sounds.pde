import processing.sound.*;
import java.util.HashMap;

class SoundManager
{
    private HashMap<String, SoundFile> sounds = new HashMap();
    
    SoundManager(PApplet parent)
    {
        this.sounds.put("jump", new SoundFile(parent, "textures/soundbump.wav"));
    }
    
    void play(String key)
    {
        SoundFile sound = this.sounds.get(key);
        if (sound != null) { sound.play(); }
    }
}