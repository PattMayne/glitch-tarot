import csfml
import random


var window = new_RenderWindow(video_mode(800, 600), "Timely Tarot")
window.vertical_sync_enabled = true

let bird_texture = new_Texture("overlay.png")
let bg_texture = new_Texture("base.png")
let pentacle_texture = new_Texture("symbol_pentacle.png")

let bg_sz = bg_texture.size
let sz = bird_texture.size
let symbol_sz = pentacle_texture.size

var bird = new_Sprite(bird_texture)
bird.origin = vec2(sz.x/2, sz.y/2) # origin is where the image is anchored (anchor point)
bird.scale = vec2(0.7, 0.7)
bird.position = vec2(window.size.x/3, window.size.y/2)

var bg = new_Sprite(bg_texture)
bg.position = vec2(0, 0)

var pentacle = new_Sprite(pentacle_texture)
let pent_scale: float = 0.25
pentacle.scale = vec2(pent_scale, pent_scale)
pentacle.origin = vec2((symbol_sz.x/2) * pent_scale, (symbol_sz.y/2) * pent_scale)

randomize()
let symbol_magnitude = rand(1..10)
let spacing = int(window.size.x / (symbol_magnitude + 2))
echo symbol_magnitude

while window.open:
    var symbol_magnitude_count = 0
    var event: Event
    while window.poll_event(event):
        case event.kind
          of EventType.Closed:
            window.close()
          of EventType.KeyPressed:
            case event.key.code
              of KeyCode.Escape:
                window.close()
              else:
                echo "something else"
          else: discard
    
    window.clear color(112, 197, 206)
    window.draw bg
    window.draw bird

    while symbol_magnitude_count < symbol_magnitude:
      if symbol_magnitude != 1:
        let x_position = (spacing * symbol_magnitude_count) + spacing
        pentacle.position = vec2(x_position, 100)
      else:
        pentacle.position = vec2(window.size.x / 2, 100)
      
      window.draw pentacle
      symbol_magnitude_count += 1

    window.display()

bird.destroy()
bird_texture.destroy()
bg.destroy()
bg_texture.destroy()
pentacle.destroy()
pentacle_texture.destroy()
window.destroy()