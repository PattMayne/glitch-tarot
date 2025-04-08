import csfml
import random

type Point = object
  x: int
  y: int

proc newPoint(newX, newY: int): Point = 
  result.x = newX
  result.y = newY


proc getSymbolPoints(number_of_points, screen_width:int): seq[Point] =
  let is_even : bool = (number_of_points mod 2) == 0
  let number_of_pairs: int = number_of_points div 2
  let screen_center : int = screen_width div 2
  let spacing = int(screen_width / (number_of_points + 2))
  var pairs_counter:int = 0

  while pairs_counter < number_of_pairs:
    let distance_from_center: int = spacing * (number_of_pairs - pairs_counter)
    let point_left_x : int = screen_center - distance_from_center
    let point_right_x : int = screen_center + distance_from_center
    let point_y : int = spacing * (number_of_pairs - pairs_counter)

    let point_left : Point = newPoint(point_left_x, point_y)
    let point_right : Point = newPoint(point_right_x, point_y)

    result.add(point_left)
    result.add(point_right)

    pairs_counter += 1

  if not is_even:
    let centre_point = newPoint(screen_center, 100)
    result.add(centre_point)

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
bg.scale = vec2(1.22, 1.22)
bg.position = vec2(0, 0)

var pentacle = new_Sprite(pentacle_texture)
let pent_scale: float = 0.25
pentacle.scale = vec2(pent_scale, pent_scale)
pentacle.origin = vec2((float(symbol_sz.x) / 2), 0)
echo "pentacle x:"
echo pentacle.origin.x

randomize()
let symbol_magnitude = rand(1..10)
echo symbol_magnitude

# make the 
let symbol_points: seq[Point] = getSymbolPoints(symbol_magnitude, window.size.x)
echo symbol_points.len

# The main loop. For web app there will be no loop.
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
    #window.draw bird

    for point in symbol_points:
      pentacle.position = vec2(point.x, point.y)
      window.draw pentacle

    window.display()

bird.destroy()
bird_texture.destroy()
bg.destroy()
bg_texture.destroy()
pentacle.destroy()
pentacle_texture.destroy()
window.destroy()