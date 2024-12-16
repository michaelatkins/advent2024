-module(day2).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([is_safe_report/2, main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/2/src/day2.gleam", 22).
-spec is_safe_report(list(binary()), integer()) -> boolean().
is_safe_report(Values, Direction) ->
    P = {gleam@list:first(Values),
        gleam@list:first(gleam@result:unwrap(gleam@list:rest(Values), []))},
    case P of
        {{ok, Sx}, {ok, Sy}} ->
            X = gleam@result:unwrap(gleam_stdlib:parse_int(Sx), -5),
            Y = gleam@result:unwrap(gleam_stdlib:parse_int(Sy), -5),
            Step = X - Y,
            Step_size = gleam@int:absolute_value(Step),
            Step_direction = case gleam@int:absolute_value(Step) of
                0 -> 0;
                Gleam@denominator -> Step div Gleam@denominator
            end,
            (((Direction =:= 0) orelse (Direction =:= Step_direction)) andalso ((0
            < Step_size)
            andalso (Step_size < 4)))
            andalso is_safe_report(
                gleam@result:unwrap(gleam@list:rest(Values), []),
                Step_direction
            );

        _ ->
            true
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2/src/day2.gleam", 8).
-spec main() -> integer().
main() ->
    case simplifile:read(<<"./data/data.txt"/utf8>>) of
        {ok, F} ->
            _pipe = F,
            _pipe@1 = gleam@string:split(_pipe, <<"\n"/utf8>>),
            _pipe@2 = gleam@list:map(
                _pipe@1,
                fun(_capture) -> gleam@string:split(_capture, <<" "/utf8>>) end
            ),
            _pipe@3 = gleam@list:filter(
                _pipe@2,
                fun(_capture@1) -> is_safe_report(_capture@1, 0) end
            ),
            _pipe@4 = erlang:length(_pipe@3),
            gleam@io:debug(_pipe@4);

        {error, _} ->
            erlang:error(#{gleam_error => panic,
                    message => <<"WTF file"/utf8>>,
                    module => <<"day2"/utf8>>,
                    function => <<"main"/utf8>>,
                    line => 18})
    end.
