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
      |> split("do()")
      |> map(split(_, "don't()"))
      |> map(fn(x) { unwrap(first(x), "") })
      |> string.join("")
      |> split("mul(")
      |> map(split(_, ")"))
      |> map(first)
      |> map(unwrap(_, ""))
      |> map(split(_, ","))
      |> map(fn(x) { #(unwrap(first(x), "0"), unwrap(first(drop(x, 1)), "0")) })
      |> map(fn(x) { #(unwrap(int.parse(x.0), 0), unwrap(int.parse(x.1), 0)) })
      |> map(fn(x) { int.multiply(x.0, x.1) })
      |> int.sum
      |> io.debug

    Error(_) -> panic as "WTF file"
  }
}
