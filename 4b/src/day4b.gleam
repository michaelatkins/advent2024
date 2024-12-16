import gleam/int
import gleam/io
import gleam/list.{filter, first, map, range, rest, zip}
import gleam/result.{unwrap}
import gleam/string.{split}
import simplifile.{read}

pub fn main() {
  let matrix = case read(from: "./data/data.txt") {
    Ok(f) ->
      f
      |> split("\n")
      |> fn(x) { zip(range(0, 139), x) }
      |> map(fn(x) { #(x.0, zip(range(0, 139), split(x.1, ""))) })
      |> map(fn(row) { map(row.1, fn(column) { #(row.0, column.0, column.1) }) })
      |> list.flatten
    Error(_) -> panic as "WTF file"
  }
  let word = "MAS"
  let main_list =
    find_word(split(word, ""), matrix, #("", []))
    |> filter(fn(x) {
      list.length(x.1) == string.length(word)
      && { x.0 == "UL" || x.0 == "UR" || x.0 == "DL" || x.0 == "DR" }
    })

  main_list
  |> filter(fn(x) {
    let match =
      list.find(main_list, fn(y) {
        let xa = unwrap(list.first(list.drop(x.1, 1)), #(-1, -1, ""))
        let ya = unwrap(list.first(list.drop(y.1, 1)), #(-1, -1, ""))
        x.0 != y.0 && xa.0 == ya.0 && xa.1 == ya.1 && xa.2 != "" && ya.2 != ""
      })

    case match {
      Ok(_) -> True
      _ -> False
    }
  })
  |> list.length
  |> int.divide(2)
  |> io.debug
}

pub fn or_empty(result) {
  unwrap(result, [])
}

pub fn find_word(
  word: List(String),
  matrix: List(#(Int, Int, String)),
  accum: #(String, List(#(Int, Int, String))),
) -> List(#(String, List(#(Int, Int, String)))) {
  let next_letter = unwrap(first(word), "")

  case word {
    [] -> [accum]
    _ -> {
      case list.length(accum.1) {
        0 ->
          filter(matrix, fn(x: #(Int, Int, String)) { x.2 == next_letter })
          |> map(fn(letter: #(Int, Int, String)) { #("", [letter]) })
          |> map(find_word(unwrap(rest(word), []), matrix, _))
          |> list.flatten
        _ -> {
          let end = unwrap(list.last(accum.1), #(-100, -100, ""))
          filter(matrix, fn(x: #(Int, Int, String)) {
            are_adjascent(end, x, accum.0) && { x.2 == next_letter }
          })
          |> map(fn(l) {
            let d = case accum.0 {
              "" -> direction(end, l)
              other -> other
            }
            #(d, list.append(accum.1, [l]))
          })
          |> map(find_word(unwrap(rest(word), []), matrix, _))
          |> list.flatten
        }
      }
    }
  }
}

pub fn are_adjascent(x: #(Int, Int, String), y: #(Int, Int, String), dir) {
  int.absolute_value(x.0 - y.0) < 2
  && int.absolute_value(x.1 - y.1) < 2
  && case dir {
    "" -> True
    _ -> dir == direction(x, y)
  }
}

pub fn direction(x: #(Int, Int, String), y: #(Int, Int, String)) {
  case x.0 - y.0 {
    0 -> ""
    1 -> "D"
    _ -> "U"
  }
  <> case x.1 - y.1 {
    0 -> ""
    1 -> "L"
    _ -> "R"
  }
}
