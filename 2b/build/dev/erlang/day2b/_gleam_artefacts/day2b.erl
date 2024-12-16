-module(day2b).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([is_safe_report/3, main/0]).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/src/day2b.gleam", 22).
-spec is_safe_report(list(binary()), integer(), boolean()) -> boolean().
is_safe_report(Values, Previous_value, Danger) ->
    P = {gleam@list:first(Values),
        gleam@list:first(gleam@result:unwrap(gleam@list:rest(Values), []))},
    case P of
        {{ok, Sx}, {ok, Sy}} ->
            X = gleam@result:unwrap(gleam_stdlib:parse_int(Sx), -100),
            Y = gleam@result:unwrap(gleam_stdlib:parse_int(Sy), -100),
            Step = X - Y,
            Step_size = gleam@int:absolute_value(Step),
            Direction_switch = not (Previous_value =:= 0) andalso (((Previous_value
            < X)
            andalso (X > Y))
            orelse ((Previous_value > X) andalso (X < Y))),
            Step_danger = ((Step_size =:= 0) orelse (Step_size > 3)) orelse Direction_switch,
            Drop_first = case Previous_value of
                0 ->
                    gleam@result:unwrap(gleam@list:rest(Values), []);

                _ ->
                    [erlang:integer_to_binary(Previous_value) |
                        gleam@result:unwrap(gleam@list:rest(Values), [])]
            end,
            Drop_second = gleam@list:drop(
                gleam@result:unwrap(gleam@list:rest(Values), []),
                1
            ),
            ((not Step_danger andalso (is_safe_report(
                gleam@result:unwrap(gleam@list:rest(Values), []),
                X,
                Danger
            )))
            orelse (not Danger andalso is_safe_report(
                Drop_first,
                Previous_value,
                true
            )))
            orelse (not Danger andalso is_safe_report(
                [Sx | Drop_second],
                Previous_value,
                true
            ));

        _ ->
            true
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/src/day2b.gleam", 8).
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
                fun(_capture@1) -> is_safe_report(_capture@1, 0, false) end
            ),
            _pipe@4 = erlang:length(_pipe@3),
            gleam@io:debug(_pipe@4);

        {error, _} ->
            erlang:error(#{gleam_error => panic,
                    message => <<"WTF file"/utf8>>,
                    module => <<"day2b"/utf8>>,
                    function => <<"main"/utf8>>,
                    line => 18})
    end.
