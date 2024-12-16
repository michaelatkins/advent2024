-module(day1b).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([count_and_multiply/2, main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/1b/src/day1b.gleam", 32).
-spec count_and_multiply(list(integer()), list(integer())) -> integer().
count_and_multiply(Left, Right) ->
    case Left of
        [] ->
            0;

        _ ->
            Left_value = gleam@result:unwrap(gleam@list:first(Left), 0),
            Left_matches = gleam@list:take_while(
                Left,
                fun(A) -> A =:= Left_value end
            ),
            Right_discards = gleam@list:drop_while(
                Right,
                fun(A@1) -> A@1 < Left_value end
            ),
            Right_matches = gleam@list:take_while(
                Right_discards,
                fun(A@2) -> A@2 =:= Left_value end
            ),
            ((Left_value * erlang:length(Left_matches)) * erlang:length(
                Right_matches
            ))
            + count_and_multiply(
                gleam@list:drop(Left, erlang:length(Left_matches)),
                gleam@list:drop(Right_discards, erlang:length(Right_matches))
            )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/1b/src/day1b.gleam", 9).
-spec main() -> integer().
main() ->
    case simplifile:read(<<"./data/data.txt"/utf8>>) of
        {ok, F} ->
            _pipe = F,
            _pipe@1 = gleam@string:split(_pipe, <<"\n"/utf8>>),
            _pipe@2 = gleam@list:map(
                _pipe@1,
                fun(Line) ->
                    Columns = gleam@string:split(Line, <<"   "/utf8>>),
                    F@1 = gleam@result:unwrap(
                        gleam@list:first(gleam@list:take(Columns, 1)),
                        <<"-1"/utf8>>
                    ),
                    S = gleam@result:unwrap(
                        gleam@list:first(
                            gleam@list:take(gleam@list:drop(Columns, 1), 1)
                        ),
                        <<"-1"/utf8>>
                    ),
                    {gleam@result:unwrap(gleam_stdlib:parse_int(F@1), -1),
                        gleam@result:unwrap(gleam_stdlib:parse_int(S), -1)}
                end
            ),
            _pipe@3 = gleam@list:unzip(_pipe@2),
            _pipe@4 = (fun(P) ->
                F@2 = gleam@list:sort(
                    gleam@pair:first(P),
                    fun gleam@int:compare/2
                ),
                S@1 = gleam@list:sort(
                    gleam@pair:second(P),
                    fun gleam@int:compare/2
                ),
                count_and_multiply(F@2, S@1)
            end)(_pipe@3),
            gleam@io:debug(_pipe@4);

        {error, _} ->
            gleam@io:debug(-1)
    end.
