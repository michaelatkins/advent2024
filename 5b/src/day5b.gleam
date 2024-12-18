import gleam/bytes_tree
import gleam/int
import gleam/io
import gleam/list.{filter, first, map, range, rest, unzip, zip}
import gleam/result.{unwrap}
import gleam/string.{split}
import simplifile.{read}

pub type Node {
  Node(value: Int, children: List(Node))
}

pub fn main() {
  let rows = case read(from: "./data/data.txt") {
    Ok(f) -> {
      let chunks = split(f, "\n\n")
      let deps = unwrap(first(chunks), "")
      let tests = unwrap(first(list.drop(chunks, 1)), "")
      let edges =
        deps
        |> split("\n")
        |> map(fn(x) { split(x, "|") })
        |> map(fn(x) {
          let a = unwrap(first(x), "-1")
          let b = unwrap(first(list.drop(x, 1)), "-1")
          let ia = int.parse(a)
          let ib = int.parse(b)

          case ia, ib {
            Ok(-1), Ok(-1) -> panic as "bad tuple"
            Ok(aa), Ok(bb) -> #(aa, bb)
            _, _ -> panic as "no idea"
          }
        })

      split(tests, "\n")
      |> map(fn(x) {
        split(x, ",")
        |> map(fn(y) { unwrap(int.parse(y), -1) })
      })
      |> filter(fn(x) { !is_ordered(x, edges, [-1]) })
      |> map(fn(x) { order_list(x, [], edges, [-1]) })
      |> map(fn(x) { list.drop(x, list.length(x) / 2) })
      |> map(fn(x) { unwrap(list.first(x), -1) })
      |> int.sum
      |> io.debug
    }
    Error(_) -> panic as "WTF file"
  }
}

pub fn is_ordered(
  nums: List(Int),
  edges: List(#(Int, Int)),
  not_allowed: List(Int),
) -> Bool {
  case nums {
    [] -> True
    _ -> {
      let num = unwrap(first(nums), -1)
      let oops = list.find(not_allowed, fn(x) { x == num })
      case oops {
        Ok(x) -> False
        _ ->
          is_ordered(
            list.drop(nums, 1),
            edges,
            list.append(not_allowed, {
              list.filter(edges, fn(x) { x.1 == num }) |> map(fn(x) { x.0 })
            }),
          )
      }
    }
  }
}

pub fn order_list(
  nums: List(Int),
  accum: List(Int),
  edges: List(#(Int, Int)),
  not_allowed: List(Int),
) -> List(Int) {
  case nums {
    [] -> {
      case is_ordered(accum, edges, [-1]) {
        True -> accum
        False -> order_list(accum, [], edges, [-1])
      }
    }
    _ -> {
      let num = unwrap(first(nums), -1)
      let oops = list.find(not_allowed, fn(x) { x == num })
      case oops {
        Ok(x) -> {
          let swapped = unwrap(list.last(accum), -1)
          let new_accum =
            list.append(list.take(accum, int.subtract(list.length(accum), 1)), [
              x,
              swapped,
            ])
          let fixed =
            order_list(
              list.drop(nums, 1),
              new_accum,
              edges,
              list.append(not_allowed, {
                list.filter(edges, fn(y) { y.1 == x }) |> map(fn(y) { y.0 })
              }),
            )
          fixed
        }
        _ ->
          order_list(
            list.drop(nums, 1),
            list.append(accum, [num]),
            edges,
            list.append(not_allowed, {
              list.filter(edges, fn(x) { x.1 == num }) |> map(fn(x) { x.0 })
            }),
          )
      }
    }
  }
}
