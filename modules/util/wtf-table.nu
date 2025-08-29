export def main [] {
  table --index false --theme none
  | append (timestamp)
  | to text
}

def timestamp [] {
  date now | format date "%H:%M"
}
