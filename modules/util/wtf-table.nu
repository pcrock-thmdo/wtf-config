export def main []: any -> nothing {
  table --index false --theme none | print
  timestamp | print
}

def timestamp []: nothing -> string {
  date now | format date "%H:%M"
}
