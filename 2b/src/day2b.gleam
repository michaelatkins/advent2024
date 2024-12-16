import gleam/int
import gleam/io
import gleam/list.{drop, each, filter, first, length, map, rest}
import gleam/result.{unwrap}
import gleam/string.{split}
import simplifile.{read}

pub fn main() {
  case read(from: "./data/data.txt") {
    Ok(f) ->
      f
      |> split("\n")
      |> map(split(_, " "))
      |> filter(is_safe_report(_, 0, False))
      |> length
      |> io.debug

    Error(_) -> panic as "WTF file"
  }
}

pub fn is_safe_report(values, previous_value, danger) {
  let p = #(first(values), first(unwrap(rest(values), [])))
  case p {
    #(Ok(sx), Ok(sy)) -> {
      let x = unwrap(int.parse(sx), -100)
      let y = unwrap(int.parse(sy), -100)
      let step = x - y
      let step_size = int.absolute_value(step)
      let direction_switch =
        !{ previous_value == 0 }
        && {
          { previous_value < x && x > y } || { previous_value > x && x < y }
        }
      let step_danger = step_size == 0 || step_size > 3 || direction_switch

      let drop_first = case previous_value {
        0 -> unwrap(rest(values), [])
        _ -> [int.to_string(previous_value), ..unwrap(rest(values), [])]
      }
      let drop_second = drop(unwrap(rest(values), []), 1)

      {
        !step_danger && { is_safe_report(unwrap(rest(values), []), x, danger) }
      }
      || { !danger && is_safe_report(drop_first, previous_value, True) }
      || {
        !danger && is_safe_report([sx, ..drop_second], previous_value, True)
      }
    }

    _ -> True
  }
}
