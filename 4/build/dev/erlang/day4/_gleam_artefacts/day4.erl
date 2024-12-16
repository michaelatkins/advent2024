-module(day4).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([direction/2, are_adjascent/3, find_word/3, main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/4/src/day4.gleam", 71).
-spec direction(
    {integer(), integer(), binary()},
    {integer(), integer(), binary()}
) -> binary().
direction(X, Y) ->
    <<(case erlang:element(1, X) - erlang:element(1, Y) of
            0 ->
                <<""/utf8>>;

            1 ->
                <<"D"/utf8>>;

            _ ->
                <<"U"/utf8>>
        end)/binary, (case erlang:element(2, X) - erlang:element(2, Y) of
            0 ->
                <<""/utf8>>;

            1 ->
                <<"L"/utf8>>;

            _ ->
                <<"R"/utf8>>
        end)/binary>>.

-file("/Users/maatkn/Documents/Code/aoc/2024/4/src/day4.gleam", 62).
-spec are_adjascent(
    {integer(), integer(), binary()},
    {integer(), integer(), binary()},
    binary()
) -> boolean().
are_adjascent(X, Y, Dir) ->
    ((gleam@int:absolute_value(erlang:element(1, X) - erlang:element(1, Y)) < 2)
    andalso (gleam@int:absolute_value(
        erlang:element(2, X) - erlang:element(2, Y)
    )
    < 2))
    andalso case Dir of
        <<""/utf8>> ->
            true;

        _ ->
            Dir =:= direction(X, Y)
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/4/src/day4.gleam", 26).
-spec find_word(
    list(binary()),
    list({integer(), integer(), binary()}),
    {binary(), list({integer(), integer(), binary()})}
) -> list({binary(), list({integer(), integer(), binary()})}).
find_word(Word, Matrix, Accum) ->
    Next_letter = gleam@result:unwrap(gleam@list:first(Word), <<""/utf8>>),
    case Word of
        [] ->
            [Accum];

        _ ->
            case erlang:length(erlang:element(2, Accum)) of
                0 ->
                    _pipe = gleam@list:filter(
                        Matrix,
                        fun(X) -> erlang:element(3, X) =:= Next_letter end
                    ),
                    _pipe@1 = gleam@list:map(
                        _pipe,
                        fun(Letter) -> {<<""/utf8>>, [Letter]} end
                    ),
                    _pipe@2 = gleam@list:map(
                        _pipe@1,
                        fun(_capture) ->
                            find_word(
                                gleam@result:unwrap(gleam@list:rest(Word), []),
                                Matrix,
                                _capture
                            )
                        end
                    ),
                    gleam@list:flatten(_pipe@2);

                _ ->
                    End = gleam@result:unwrap(
                        gleam@list:last(erlang:element(2, Accum)),
                        {-100, -100, <<""/utf8>>}
                    ),
                    _pipe@3 = gleam@list:filter(
                        Matrix,
                        fun(X@1) ->
                            are_adjascent(End, X@1, erlang:element(1, Accum))
                            andalso (erlang:element(3, X@1) =:= Next_letter)
                        end
                    ),
                    _pipe@4 = gleam@list:map(
                        _pipe@3,
                        fun(L) ->
                            D = case erlang:element(1, Accum) of
                                <<""/utf8>> ->
                                    direction(End, L);

                                Other ->
                                    Other
                            end,
                            {D, lists:append(erlang:element(2, Accum), [L])}
                        end
                    ),
                    _pipe@5 = gleam@list:map(
                        _pipe@4,
                        fun(_capture@1) ->
                            find_word(
                                gleam@result:unwrap(gleam@list:rest(Word), []),
                                Matrix,
                                _capture@1
                            )
                        end
                    ),
                    gleam@list:flatten(_pipe@5)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/4/src/day4.gleam", 8).
-spec main() -> integer().
main() ->
    Matrix = case simplifile:read(<<"./data/data.txt"/utf8>>) of
        {ok, F} ->
            _pipe = F,
            _pipe@1 = gleam@string:split(_pipe, <<"\n"/utf8>>),
            _pipe@2 = (fun(X) -> gleam@list:zip(gleam@list:range(0, 139), X) end)(
                _pipe@1
            ),
            _pipe@3 = gleam@list:map(
                _pipe@2,
                fun(X@1) ->
                    {erlang:element(1, X@1),
                        gleam@list:zip(
                            gleam@list:range(0, 139),
                            gleam@string:split(
                                erlang:element(2, X@1),
                                <<""/utf8>>
                            )
                        )}
                end
            ),
            _pipe@4 = gleam@list:map(
                _pipe@3,
                fun(Row) ->
                    gleam@list:map(
                        erlang:element(2, Row),
                        fun(Column) ->
                            {erlang:element(1, Row),
                                erlang:element(1, Column),
                                erlang:element(2, Column)}
                        end
                    )
                end
            ),
            gleam@list:flatten(_pipe@4);

        {error, _} ->
            erlang:error(#{gleam_error => panic,
                    message => <<"WTF file"/utf8>>,
                    module => <<"day4"/utf8>>,
                    function => <<"main"/utf8>>,
                    line => 17})
    end,
    Word = <<"XMAS"/utf8>>,
    _pipe@5 = find_word(
        gleam@string:split(Word, <<""/utf8>>),
        Matrix,
        {<<""/utf8>>, []}
    ),
    _pipe@6 = gleam@list:filter(
        _pipe@5,
        fun(X@2) ->
            erlang:length(erlang:element(2, X@2)) =:= string:length(Word)
        end
    ),
    _pipe@7 = erlang:length(_pipe@6),
    gleam@io:debug(_pipe@7).
