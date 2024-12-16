-module(day3).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/3/src/day3.gleam", 8).
-spec main() -> integer().
main() ->
    case simplifile:read(<<"./data/data.txt"/utf8>>) of
        {ok, F} ->
            _pipe = F,
            _pipe@1 = gleam@string:split(_pipe, <<"do()"/utf8>>),
            _pipe@2 = gleam@list:map(
                _pipe@1,
                fun(_capture) ->
                    gleam@string:split(_capture, <<"don't()"/utf8>>)
                end
            ),
            _pipe@3 = gleam@list:map(
                _pipe@2,
                fun(X) ->
                    gleam@result:unwrap(gleam@list:first(X), <<""/utf8>>)
                end
            ),
            _pipe@4 = gleam@string:join(_pipe@3, <<""/utf8>>),
            _pipe@5 = gleam@string:split(_pipe@4, <<"mul("/utf8>>),
            _pipe@6 = gleam@list:map(
                _pipe@5,
                fun(_capture@1) ->
                    gleam@string:split(_capture@1, <<")"/utf8>>)
                end
            ),
            _pipe@7 = gleam@list:map(_pipe@6, fun gleam@list:first/1),
            _pipe@8 = gleam@list:map(
                _pipe@7,
                fun(_capture@2) ->
                    gleam@result:unwrap(_capture@2, <<""/utf8>>)
                end
            ),
            _pipe@9 = gleam@list:map(
                _pipe@8,
                fun(_capture@3) ->
                    gleam@string:split(_capture@3, <<","/utf8>>)
                end
            ),
            _pipe@10 = gleam@list:map(
                _pipe@9,
                fun(X@1) ->
                    {gleam@result:unwrap(gleam@list:first(X@1), <<"0"/utf8>>),
                        gleam@result:unwrap(
                            gleam@list:first(gleam@list:drop(X@1, 1)),
                            <<"0"/utf8>>
                        )}
                end
            ),
            _pipe@11 = gleam@list:map(
                _pipe@10,
                fun(X@2) ->
                    {gleam@result:unwrap(
                            gleam_stdlib:parse_int(erlang:element(1, X@2)),
                            0
                        ),
                        gleam@result:unwrap(
                            gleam_stdlib:parse_int(erlang:element(2, X@2)),
                            0
                        )}
                end
            ),
            _pipe@12 = gleam@list:map(
                _pipe@11,
                fun(X@3) ->
                    gleam@int:multiply(
                        erlang:element(1, X@3),
                        erlang:element(2, X@3)
                    )
                end
            ),
            _pipe@13 = gleam@int:sum(_pipe@12),
            gleam@io:debug(_pipe@13);

        {error, _} ->
            erlang:error(#{gleam_error => panic,
                    message => <<"WTF file"/utf8>>,
                    module => <<"day3"/utf8>>,
                    function => <<"main"/utf8>>,
                    line => 27})
    end.
