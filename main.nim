import csfml
import random
import tables

randomize()

var number_word_table : Table[int, string]
number_word_table[1] = "One"
number_word_table[2] = "Two"
number_word_table[3] = "Three"
number_word_table[4] = "For"
number_word_table[5] = "Five"
number_word_table[6] = "Six"
number_word_table[7] = "Seven"
number_word_table[8] = "Eight"
number_word_table[9] = "Nine"
number_word_table[10] = "Ten"

# Functions and Object Definitions

type Symbol = object
  name: string
  path: string

type Point = object
  x: int
  y: int

proc newPoint(newX, newY: int): Point = 
  result.x = newX
  result.y = newY

proc newSymbol(newName, newPath: string): Symbol =
  result.name = newName
  result.path = newPath


proc getCardTitle(num: int, symbol_text: string) : string =
  var return_string: string = if num in number_word_table:
    number_word_table[num] & " of "
    else: ""
  return_string = return_string & symbol_text
  return return_string

# Create a seq of x,y coords where the Symbol objects should be printed.
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

let symbol_paths: array[4, Symbol] = [
  newSymbol("Pentacles", "symbol_pentacle.png"),
  newSymbol("Cups", "symbol_cup.png"),
  newSymbol("Guns", "symbol_gun.png"),
  newSymbol("Interfaces", "symbol_keyboard.png")
]

let symbol: Symbol = symbol_paths[rand(0..len(symbol_paths) - 1)]
let symbol_path : string = symbol.path

var window = new_RenderWindow(video_mode(800, 600), "Timely Tarot")
window.vertical_sync_enabled = true

let bird_texture = new_Texture("overlay.png")
let bg_texture = new_Texture("base.png")
let pentacle_texture = new_Texture(symbol_path.cstring)

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
let symbol_magnitude = rand(1..10)

let card_title: string = getCardTitle(symbol_magnitude, symbol.name)
echo card_title

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