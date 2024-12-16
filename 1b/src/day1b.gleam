import gleam/int
import gleam/io
import gleam/list.{drop, first, length, map, sort, take, unzip}
import gleam/pair
import gleam/result
import gleam/string.{split}
import simplifile.{read}

pub fn main() {
  case read(from: "./data/data.txt") {
    Ok(f) ->
      f
      |> split("\n")
      |> map(fn(line) {
        let columns = split(line, "   ")
        let f = result.unwrap(first(take(columns, 1)), "-1")
        let s = result.unwrap(first(take(drop(columns, 1), 1)), "-1")
        #(result.unwrap(int.parse(f), -1), result.unwrap(int.parse(s), -1))
      })
      |> unzip
      |> fn(p) {
        let f = sort(pair.first(p), by: int.compare)
        let s = sort(pair.second(p), by: int.compare)
        count_and_multiply(f, s)
      }
      |> io.debug

    Error(_) -> io.debug(-1)
  }
}

//assumes we start with two sorted lists so dropping items makes sense
pub fn count_and_multiply(left, right) {
  case left {
    [] -> 0
    _ -> {
      let left_value = result.unwrap(first(left), 0)
      let left_matches = list.take_while(left, fn(a) { a == left_value })
      let right_discards = list.drop_while(right, fn(a) { a < left_value })
      let right_matches =
        list.take_while(right_discards, fn(a) { a == left_value })

      left_value
      * length(left_matches)
      * length(right_matches)
      + count_and_multiply(
        drop(left, length(left_matches)),
        drop(right_discards, length(right_matches)),
      )
    }
  }
}
