-module(day1).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/1/src/day1.gleam", 9).
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
                gleam@list:zip(F@2, S@1)
            end)(_pipe@3),
            _pipe@5 = gleam@list:map(
                _pipe@4,
                fun(P@1) ->
                    gleam@int:absolute_value(
                        gleam@int:subtract(
                            gleam@pair:first(P@1),
                            gleam@pair:second(P@1)
                        )
                    )
                end
            ),
            _pipe@6 = gleam@int:sum(_pipe@5),
            gleam@io:debug(_pipe@6);

        {error, _} ->
            gleam@io:debug(-1)
    end.
