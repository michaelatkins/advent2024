import gleam/int
import gleam/io
import gleam/list.{drop, first, map, sort, take, unzip, zip}
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
        zip(f, s)
      }
      |> map(fn(p) {
        int.absolute_value(int.subtract(pair.first(p), pair.second(p)))
      })
      |> int.sum
      |> io.debug

    Error(_) -> io.debug(-1)
  }
}
