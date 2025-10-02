export def truncate [max_length: int] {
  if ($in | str length) > $max_length {
    ($in | str substring 0..($max_length - 1)) + "…"
  } else {
    $in
  }
}
