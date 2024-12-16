-module(gleam@set).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, size/1, is_empty/1, contains/2, delete/2, to_list/1, fold/3, filter/2, drop/2, take/2, intersection/2, difference/2, is_subset/2, is_disjoint/2, each/2, insert/2, from_list/1, map/2, union/2, symmetric_difference/2]).
-export_type([set/1]).

-opaque set(FAO) :: {set, gleam@dict:dict(FAO, list(nil))}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 32).
-spec new() -> set(any()).
new() ->
    {set, maps:new()}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 50).
-spec size(set(any())) -> integer().
size(Set) ->
    maps:size(erlang:element(2, Set)).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 68).
-spec is_empty(set(any())) -> boolean().
is_empty(Set) ->
    Set =:= new().

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 110).
-spec contains(set(FAZ), FAZ) -> boolean().
contains(Set, Member) ->
    _pipe = erlang:element(2, Set),
    _pipe@1 = gleam_stdlib:map_get(_pipe, Member),
    gleam@result:is_ok(_pipe@1).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 131).
-spec delete(set(FBB), FBB) -> set(FBB).
delete(Set, Member) ->
    {set, gleam@dict:delete(erlang:element(2, Set), Member)}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 149).
-spec to_list(set(FBE)) -> list(FBE).
to_list(Set) ->
    maps:keys(erlang:element(2, Set)).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 190).
-spec fold(set(FBK), FBM, fun((FBM, FBK) -> FBM)) -> FBM.
fold(Set, Initial, Reducer) ->
    gleam@dict:fold(
        erlang:element(2, Set),
        Initial,
        fun(A, K, _) -> Reducer(A, K) end
    ).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 214).
-spec filter(set(FBN), fun((FBN) -> boolean())) -> set(FBN).
filter(Set, Predicate) ->
    {set,
        gleam@dict:filter(erlang:element(2, Set), fun(M, _) -> Predicate(M) end)}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 249).
-spec drop(set(FBU), list(FBU)) -> set(FBU).
drop(Set, Disallowed) ->
    gleam@list:fold(Disallowed, Set, fun delete/2).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 267).
-spec take(set(FBY), list(FBY)) -> set(FBY).
take(Set, Desired) ->
    {set, gleam@dict:take(erlang:element(2, Set), Desired)}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 287).
-spec order(set(FCG), set(FCG)) -> {set(FCG), set(FCG)}.
order(First, Second) ->
    case maps:size(erlang:element(2, First)) > maps:size(
        erlang:element(2, Second)
    ) of
        true ->
            {First, Second};

        false ->
            {Second, First}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 305).
-spec intersection(set(FCL), set(FCL)) -> set(FCL).
intersection(First, Second) ->
    {Larger, Smaller} = order(First, Second),
    take(Larger, to_list(Smaller)).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 323).
-spec difference(set(FCP), set(FCP)) -> set(FCP).
difference(First, Second) ->
    drop(First, to_list(Second)).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 344).
-spec is_subset(set(FCT), set(FCT)) -> boolean().
is_subset(First, Second) ->
    intersection(First, Second) =:= First.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 362).
-spec is_disjoint(set(FCW), set(FCW)) -> boolean().
is_disjoint(First, Second) ->
    intersection(First, Second) =:= new().

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 402).
-spec each(set(FDD), fun((FDD) -> any())) -> nil.
each(Set, Fun) ->
    fold(
        Set,
        nil,
        fun(Nil, Member) ->
            Fun(Member),
            Nil
        end
    ).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 86).
-spec insert(set(FAW), FAW) -> set(FAW).
insert(Set, Member) ->
    {set, gleam@dict:insert(erlang:element(2, Set), Member, [])}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 167).
-spec from_list(list(FBH)) -> set(FBH).
from_list(Members) ->
    Dict = gleam@list:fold(
        Members,
        maps:new(),
        fun(M, K) -> gleam@dict:insert(M, K, []) end
    ),
    {set, Dict}.

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 232).
-spec map(set(FBQ), fun((FBQ) -> FBS)) -> set(FBS).
map(Set, Fun) ->
    fold(Set, new(), fun(Acc, Member) -> insert(Acc, Fun(Member)) end).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 282).
-spec union(set(FCC), set(FCC)) -> set(FCC).
union(First, Second) ->
    {Larger, Smaller} = order(First, Second),
    fold(Smaller, Larger, fun insert/2).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/build/packages/gleam_stdlib/src/gleam/set.gleam", 374).
-spec symmetric_difference(set(FCZ), set(FCZ)) -> set(FCZ).
symmetric_difference(First, Second) ->
    difference(union(First, Second), intersection(First, Second)).
