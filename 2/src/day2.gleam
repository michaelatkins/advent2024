import gleam/int
import gleam/io
import gleam/list.{filter, first, length, map, rest}
import gleam/result.{unwrap}
import gleam/string.{split}
import simplifile.{read}

pub fn main() {
  case read(from: "./data/data.txt") {
    Ok(f) ->
      f
      |> split("\n")
      |> map(split(_, " "))
      |> filter(is_safe_report(_, 0))
      |> length
      |> io.debug

    Error(_) -> panic as "WTF file"
  }
}

pub fn is_safe_report(values, direction) {
  let p = #(first(values), first(unwrap(rest(values), [])))
  case p {
    #(Ok(sx), Ok(sy)) -> {
      let x = unwrap(int.parse(sx), -5)
      let y = unwrap(int.parse(sy), -5)
      let step = x - y
      let step_size = int.absolute_value(step)
      let step_direction = step / int.absolute_value(step)
      { direction == 0 || direction == step_direction }
      && { 0 < step_size && step_size < 4 }
      && is_safe_report(unwrap(rest(values), []), step_direction)
    }
    _ -> True
  }
}
