-module(gleam@dynamic).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([from/1, dynamic/1, bit_array/1, classify/1, int/1, float/1, bool/1, shallow_list/1, optional/1, any/1, decode1/2, result/2, list/1, string/1, field/2, optional_field/2, element/2, tuple2/2, tuple3/3, tuple4/4, tuple5/5, tuple6/6, dict/2, decode2/3, decode3/4, decode4/5, decode5/6, decode6/7, decode7/8, decode8/9, decode9/10]).
-export_type([dynamic_/0, decode_error/0, unknown_tuple/0]).

-type dynamic_() :: any().

-type decode_error() :: {decode_error, binary(), binary(), list(binary())}.

-type unknown_tuple() :: any().

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 31).
-spec from(any()) -> dynamic_().
from(A) ->
    gleam_stdlib:identity(A).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 39).
-spec dynamic(dynamic_()) -> {ok, dynamic_()} | {error, list(decode_error())}.
dynamic(Value) ->
    {ok, Value}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 60).
-spec bit_array(dynamic_()) -> {ok, bitstring()} | {error, list(decode_error())}.
bit_array(Data) ->
    gleam_stdlib:decode_bit_array(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 107).
-spec put_expected(decode_error(), binary()) -> decode_error().
put_expected(Error, Expected) ->
    erlang:setelement(2, Error, Expected).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 120).
-spec classify(dynamic_()) -> binary().
classify(Data) ->
    gleam_stdlib:classify_dynamic(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 137).
-spec int(dynamic_()) -> {ok, integer()} | {error, list(decode_error())}.
int(Data) ->
    gleam_stdlib:decode_int(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 160).
-spec float(dynamic_()) -> {ok, float()} | {error, list(decode_error())}.
float(Data) ->
    gleam_stdlib:decode_float(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 183).
-spec bool(dynamic_()) -> {ok, boolean()} | {error, list(decode_error())}.
bool(Data) ->
    gleam_stdlib:decode_bool(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 209).
-spec shallow_list(dynamic_()) -> {ok, list(dynamic_())} |
    {error, list(decode_error())}.
shallow_list(Value) ->
    gleam_stdlib:decode_list(Value).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 352).
-spec optional(fun((dynamic_()) -> {ok, CHE} | {error, list(decode_error())})) -> fun((dynamic_()) -> {ok,
        gleam@option:option(CHE)} |
    {error, list(decode_error())}).
optional(Decode) ->
    fun(Value) -> gleam_stdlib:decode_option(Value, Decode) end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 487).
-spec at_least_decode_tuple_error(integer(), dynamic_()) -> {ok, any()} |
    {error, list(decode_error())}.
at_least_decode_tuple_error(Size, Data) ->
    S = case Size of
        1 ->
            <<""/utf8>>;

        _ ->
            <<"s"/utf8>>
    end,
    Error = begin
        _pipe = [<<"Tuple of at least "/utf8>>,
            erlang:integer_to_binary(Size),
            <<" element"/utf8>>,
            S],
        _pipe@1 = gleam_stdlib:identity(_pipe),
        _pipe@2 = unicode:characters_to_binary(_pipe@1),
        {decode_error, _pipe@2, gleam_stdlib:classify_dynamic(Data), []}
    end,
    {error, [Error]}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1017).
-spec any(list(fun((dynamic_()) -> {ok, CLE} | {error, list(decode_error())}))) -> fun((dynamic_()) -> {ok,
        CLE} |
    {error, list(decode_error())}).
any(Decoders) ->
    fun(Data) -> case Decoders of
            [] ->
                {error,
                    [{decode_error,
                            <<"another type"/utf8>>,
                            gleam_stdlib:classify_dynamic(Data),
                            []}]};

            [Decoder | Decoders@1] ->
                case Decoder(Data) of
                    {ok, Decoded} ->
                        {ok, Decoded};

                    {error, _} ->
                        (any(Decoders@1))(Data)
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1513).
-spec all_errors({ok, any()} | {error, list(decode_error())}) -> list(decode_error()).
all_errors(Result) ->
    case Result of
        {ok, _} ->
            [];

        {error, Errors} ->
            Errors
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1050).
-spec decode1(
    fun((CLI) -> CLJ),
    fun((dynamic_()) -> {ok, CLI} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CLJ} | {error, list(decode_error())}).
decode1(Constructor, T1) ->
    fun(Value) -> case T1(Value) of
            {ok, A} ->
                {ok, Constructor(A)};

            A@1 ->
                {error, all_errors(A@1)}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 559).
-spec push_path(decode_error(), any()) -> decode_error().
push_path(Error, Name) ->
    Name@1 = gleam_stdlib:identity(Name),
    Decoder = any(
        [fun string/1,
            fun(X) ->
                gleam@result:map(int(X), fun erlang:integer_to_binary/1)
            end]
    ),
    Name@3 = case Decoder(Name@1) of
        {ok, Name@2} ->
            Name@2;

        {error, _} ->
            _pipe = [<<"<"/utf8>>,
                gleam_stdlib:classify_dynamic(Name@1),
                <<">"/utf8>>],
            _pipe@1 = gleam_stdlib:identity(_pipe),
            unicode:characters_to_binary(_pipe@1)
    end,
    erlang:setelement(4, Error, [Name@3 | erlang:element(4, Error)]).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 240).
-spec result(
    fun((dynamic_()) -> {ok, CGM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CGO} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {ok, CGM} | {error, CGO}} |
    {error, list(decode_error())}).
result(Decode_ok, Decode_error) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_result(Value),
            fun(Inner_result) -> case Inner_result of
                    {ok, Raw} ->
                        gleam@result:'try'(
                            begin
                                _pipe = Decode_ok(Raw),
                                map_errors(
                                    _pipe,
                                    fun(_capture) ->
                                        push_path(_capture, <<"ok"/utf8>>)
                                    end
                                )
                            end,
                            fun(Value@1) -> {ok, {ok, Value@1}} end
                        );

                    {error, Raw@1} ->
                        gleam@result:'try'(
                            begin
                                _pipe@1 = Decode_error(Raw@1),
                                map_errors(
                                    _pipe@1,
                                    fun(_capture@1) ->
                                        push_path(_capture@1, <<"error"/utf8>>)
                                    end
                                )
                            end,
                            fun(Value@2) -> {ok, {error, Value@2}} end
                        )
                end end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 297).
-spec list(fun((dynamic_()) -> {ok, CGZ} | {error, list(decode_error())})) -> fun((dynamic_()) -> {ok,
        list(CGZ)} |
    {error, list(decode_error())}).
list(Decoder_type) ->
    fun(Dynamic) ->
        gleam@result:'try'(shallow_list(Dynamic), fun(List) -> _pipe = List,
                _pipe@1 = gleam@list:try_map(_pipe, Decoder_type),
                map_errors(
                    _pipe@1,
                    fun(_capture) -> push_path(_capture, <<"*"/utf8>>) end
                ) end)
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 87).
-spec map_errors(
    {ok, CFN} | {error, list(decode_error())},
    fun((decode_error()) -> decode_error())
) -> {ok, CFN} | {error, list(decode_error())}.
map_errors(Result, F) ->
    gleam@result:map_error(
        Result,
        fun(_capture) -> gleam@list:map(_capture, F) end
    ).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 95).
-spec decode_string(dynamic_()) -> {ok, binary()} |
    {error, list(decode_error())}.
decode_string(Data) ->
    _pipe = bit_array(Data),
    _pipe@1 = map_errors(
        _pipe,
        fun(_capture) -> put_expected(_capture, <<"String"/utf8>>) end
    ),
    gleam@result:'try'(
        _pipe@1,
        fun(Raw) -> case gleam@bit_array:to_string(Raw) of
                {ok, String} ->
                    {ok, String};

                {error, nil} ->
                    {error,
                        [{decode_error,
                                <<"String"/utf8>>,
                                <<"BitArray"/utf8>>,
                                []}]}
            end end
    ).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 83).
-spec string(dynamic_()) -> {ok, binary()} | {error, list(decode_error())}.
string(Data) ->
    decode_string(Data).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 381).
-spec field(
    any(),
    fun((dynamic_()) -> {ok, CHO} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CHO} | {error, list(decode_error())}).
field(Name, Inner_type) ->
    fun(Value) ->
        Missing_field_error = {decode_error,
            <<"field"/utf8>>,
            <<"nothing"/utf8>>,
            []},
        gleam@result:'try'(
            gleam_stdlib:decode_field(Value, Name),
            fun(Maybe_inner) -> _pipe = Maybe_inner,
                _pipe@1 = gleam@option:to_result(_pipe, [Missing_field_error]),
                _pipe@2 = gleam@result:'try'(_pipe@1, Inner_type),
                map_errors(
                    _pipe@2,
                    fun(_capture) -> push_path(_capture, Name) end
                ) end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 423).
-spec optional_field(
    any(),
    fun((dynamic_()) -> {ok, CHS} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, gleam@option:option(CHS)} |
    {error, list(decode_error())}).
optional_field(Name, Inner_type) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_field(Value, Name),
            fun(Maybe_inner) -> case Maybe_inner of
                    none ->
                        {ok, none};

                    {some, Dynamic_inner} ->
                        _pipe = Inner_type(Dynamic_inner),
                        _pipe@1 = gleam@result:map(
                            _pipe,
                            fun(Field@0) -> {some, Field@0} end
                        ),
                        map_errors(
                            _pipe@1,
                            fun(_capture) -> push_path(_capture, Name) end
                        )
                end end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 466).
-spec element(
    integer(),
    fun((dynamic_()) -> {ok, CIA} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CIA} | {error, list(decode_error())}).
element(Index, Inner_type) ->
    fun(Data) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple(Data),
            fun(Tuple) ->
                Size = gleam_stdlib:size_of_tuple(Tuple),
                gleam@result:'try'(case Index >= 0 of
                        true ->
                            case Index < Size of
                                true ->
                                    gleam_stdlib:tuple_get(Tuple, Index);

                                false ->
                                    at_least_decode_tuple_error(Index + 1, Data)
                            end;

                        false ->
                            case gleam@int:absolute_value(Index) =< Size of
                                true ->
                                    gleam_stdlib:tuple_get(Tuple, Size + Index);

                                false ->
                                    at_least_decode_tuple_error(
                                        gleam@int:absolute_value(Index),
                                        Data
                                    )
                            end
                    end, fun(Data@1) -> _pipe = Inner_type(Data@1),
                        map_errors(
                            _pipe,
                            fun(_capture) -> push_path(_capture, Index) end
                        ) end)
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 549).
-spec tuple_errors({ok, any()} | {error, list(decode_error())}, binary()) -> list(decode_error()).
tuple_errors(Result, Name) ->
    case Result of
        {ok, _} ->
            [];

        {error, Errors} ->
            gleam@list:map(
                Errors,
                fun(_capture) -> push_path(_capture, Name) end
            )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 625).
-spec tuple2(
    fun((dynamic_()) -> {ok, CJA} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJC} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {CJA, CJC}} | {error, list(decode_error())}).
tuple2(Decode1, Decode2) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple2(Value),
            fun(_use0) ->
                {A, B} = _use0,
                case {Decode1(A), Decode2(B)} of
                    {{ok, A@1}, {ok, B@1}} ->
                        {ok, {A@1, B@1}};

                    {A@2, B@2} ->
                        _pipe = tuple_errors(A@2, <<"0"/utf8>>),
                        _pipe@1 = lists:append(
                            _pipe,
                            tuple_errors(B@2, <<"1"/utf8>>)
                        ),
                        {error, _pipe@1}
                end
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 694).
-spec tuple3(
    fun((dynamic_()) -> {ok, CJF} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJH} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJJ} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {CJF, CJH, CJJ}} | {error, list(decode_error())}).
tuple3(Decode1, Decode2, Decode3) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple3(Value),
            fun(_use0) ->
                {A, B, C} = _use0,
                case {Decode1(A), Decode2(B), Decode3(C)} of
                    {{ok, A@1}, {ok, B@1}, {ok, C@1}} ->
                        {ok, {A@1, B@1, C@1}};

                    {A@2, B@2, C@2} ->
                        _pipe = tuple_errors(A@2, <<"0"/utf8>>),
                        _pipe@1 = lists:append(
                            _pipe,
                            tuple_errors(B@2, <<"1"/utf8>>)
                        ),
                        _pipe@2 = lists:append(
                            _pipe@1,
                            tuple_errors(C@2, <<"2"/utf8>>)
                        ),
                        {error, _pipe@2}
                end
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 765).
-spec tuple4(
    fun((dynamic_()) -> {ok, CJM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJO} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJQ} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJS} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {CJM, CJO, CJQ, CJS}} |
    {error, list(decode_error())}).
tuple4(Decode1, Decode2, Decode3, Decode4) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple4(Value),
            fun(_use0) ->
                {A, B, C, D} = _use0,
                case {Decode1(A), Decode2(B), Decode3(C), Decode4(D)} of
                    {{ok, A@1}, {ok, B@1}, {ok, C@1}, {ok, D@1}} ->
                        {ok, {A@1, B@1, C@1, D@1}};

                    {A@2, B@2, C@2, D@2} ->
                        _pipe = tuple_errors(A@2, <<"0"/utf8>>),
                        _pipe@1 = lists:append(
                            _pipe,
                            tuple_errors(B@2, <<"1"/utf8>>)
                        ),
                        _pipe@2 = lists:append(
                            _pipe@1,
                            tuple_errors(C@2, <<"2"/utf8>>)
                        ),
                        _pipe@3 = lists:append(
                            _pipe@2,
                            tuple_errors(D@2, <<"3"/utf8>>)
                        ),
                        {error, _pipe@3}
                end
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 838).
-spec tuple5(
    fun((dynamic_()) -> {ok, CJV} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJX} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CJZ} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKB} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKD} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {CJV, CJX, CJZ, CKB, CKD}} |
    {error, list(decode_error())}).
tuple5(Decode1, Decode2, Decode3, Decode4, Decode5) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple5(Value),
            fun(_use0) ->
                {A, B, C, D, E} = _use0,
                case {Decode1(A),
                    Decode2(B),
                    Decode3(C),
                    Decode4(D),
                    Decode5(E)} of
                    {{ok, A@1}, {ok, B@1}, {ok, C@1}, {ok, D@1}, {ok, E@1}} ->
                        {ok, {A@1, B@1, C@1, D@1, E@1}};

                    {A@2, B@2, C@2, D@2, E@2} ->
                        _pipe = tuple_errors(A@2, <<"0"/utf8>>),
                        _pipe@1 = lists:append(
                            _pipe,
                            tuple_errors(B@2, <<"1"/utf8>>)
                        ),
                        _pipe@2 = lists:append(
                            _pipe@1,
                            tuple_errors(C@2, <<"2"/utf8>>)
                        ),
                        _pipe@3 = lists:append(
                            _pipe@2,
                            tuple_errors(D@2, <<"3"/utf8>>)
                        ),
                        _pipe@4 = lists:append(
                            _pipe@3,
                            tuple_errors(E@2, <<"4"/utf8>>)
                        ),
                        {error, _pipe@4}
                end
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 913).
-spec tuple6(
    fun((dynamic_()) -> {ok, CKG} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKI} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKK} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKO} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKQ} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, {CKG, CKI, CKK, CKM, CKO, CKQ}} |
    {error, list(decode_error())}).
tuple6(Decode1, Decode2, Decode3, Decode4, Decode5, Decode6) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_tuple6(Value),
            fun(_use0) ->
                {A, B, C, D, E, F} = _use0,
                case {Decode1(A),
                    Decode2(B),
                    Decode3(C),
                    Decode4(D),
                    Decode5(E),
                    Decode6(F)} of
                    {{ok, A@1},
                        {ok, B@1},
                        {ok, C@1},
                        {ok, D@1},
                        {ok, E@1},
                        {ok, F@1}} ->
                        {ok, {A@1, B@1, C@1, D@1, E@1, F@1}};

                    {A@2, B@2, C@2, D@2, E@2, F@2} ->
                        _pipe = tuple_errors(A@2, <<"0"/utf8>>),
                        _pipe@1 = lists:append(
                            _pipe,
                            tuple_errors(B@2, <<"1"/utf8>>)
                        ),
                        _pipe@2 = lists:append(
                            _pipe@1,
                            tuple_errors(C@2, <<"2"/utf8>>)
                        ),
                        _pipe@3 = lists:append(
                            _pipe@2,
                            tuple_errors(D@2, <<"3"/utf8>>)
                        ),
                        _pipe@4 = lists:append(
                            _pipe@3,
                            tuple_errors(E@2, <<"4"/utf8>>)
                        ),
                        _pipe@5 = lists:append(
                            _pipe@4,
                            tuple_errors(F@2, <<"5"/utf8>>)
                        ),
                        {error, _pipe@5}
                end
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 964).
-spec dict(
    fun((dynamic_()) -> {ok, CKT} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CKV} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, gleam@dict:dict(CKT, CKV)} |
    {error, list(decode_error())}).
dict(Key_type, Value_type) ->
    fun(Value) ->
        gleam@result:'try'(
            gleam_stdlib:decode_map(Value),
            fun(Dict) ->
                gleam@result:'try'(
                    begin
                        _pipe = Dict,
                        _pipe@1 = maps:to_list(_pipe),
                        gleam@list:try_map(
                            _pipe@1,
                            fun(Pair) ->
                                {K, V} = Pair,
                                gleam@result:'try'(
                                    begin
                                        _pipe@2 = Key_type(K),
                                        map_errors(
                                            _pipe@2,
                                            fun(_capture) ->
                                                push_path(
                                                    _capture,
                                                    <<"keys"/utf8>>
                                                )
                                            end
                                        )
                                    end,
                                    fun(K@1) ->
                                        gleam@result:'try'(
                                            begin
                                                _pipe@3 = Value_type(V),
                                                map_errors(
                                                    _pipe@3,
                                                    fun(_capture@1) ->
                                                        push_path(
                                                            _capture@1,
                                                            <<"values"/utf8>>
                                                        )
                                                    end
                                                )
                                            end,
                                            fun(V@1) -> {ok, {K@1, V@1}} end
                                        )
                                    end
                                )
                            end
                        )
                    end,
                    fun(Pairs) -> {ok, maps:from_list(Pairs)} end
                )
            end
        )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1078).
-spec decode2(
    fun((CLM, CLN) -> CLO),
    fun((dynamic_()) -> {ok, CLM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CLN} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CLO} | {error, list(decode_error())}).
decode2(Constructor, T1, T2) ->
    fun(Value) -> case {T1(Value), T2(Value)} of
            {{ok, A}, {ok, B}} ->
                {ok, Constructor(A, B)};

            {A@1, B@1} ->
                {error, gleam@list:flatten([all_errors(A@1), all_errors(B@1)])}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1110).
-spec decode3(
    fun((CLS, CLT, CLU) -> CLV),
    fun((dynamic_()) -> {ok, CLS} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CLT} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CLU} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CLV} | {error, list(decode_error())}).
decode3(Constructor, T1, T2, T3) ->
    fun(Value) -> case {T1(Value), T2(Value), T3(Value)} of
            {{ok, A}, {ok, B}, {ok, C}} ->
                {ok, Constructor(A, B, C)};

            {A@1, B@1, C@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1), all_errors(B@1), all_errors(C@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1156).
-spec decode4(
    fun((CMA, CMB, CMC, CMD) -> CME),
    fun((dynamic_()) -> {ok, CMA} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMB} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMC} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMD} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CME} | {error, list(decode_error())}).
decode4(Constructor, T1, T2, T3, T4) ->
    fun(X) -> case {T1(X), T2(X), T3(X), T4(X)} of
            {{ok, A}, {ok, B}, {ok, C}, {ok, D}} ->
                {ok, Constructor(A, B, C, D)};

            {A@1, B@1, C@1, D@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1212).
-spec decode5(
    fun((CMK, CML, CMM, CMN, CMO) -> CMP),
    fun((dynamic_()) -> {ok, CMK} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CML} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMN} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMO} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CMP} | {error, list(decode_error())}).
decode5(Constructor, T1, T2, T3, T4, T5) ->
    fun(X) -> case {T1(X), T2(X), T3(X), T4(X), T5(X)} of
            {{ok, A}, {ok, B}, {ok, C}, {ok, D}, {ok, E}} ->
                {ok, Constructor(A, B, C, D, E)};

            {A@1, B@1, C@1, D@1, E@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1),
                            all_errors(E@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1272).
-spec decode6(
    fun((CMW, CMX, CMY, CMZ, CNA, CNB) -> CNC),
    fun((dynamic_()) -> {ok, CMW} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMX} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMY} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CMZ} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNA} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNB} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CNC} | {error, list(decode_error())}).
decode6(Constructor, T1, T2, T3, T4, T5, T6) ->
    fun(X) -> case {T1(X), T2(X), T3(X), T4(X), T5(X), T6(X)} of
            {{ok, A}, {ok, B}, {ok, C}, {ok, D}, {ok, E}, {ok, F}} ->
                {ok, Constructor(A, B, C, D, E, F)};

            {A@1, B@1, C@1, D@1, E@1, F@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1),
                            all_errors(E@1),
                            all_errors(F@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1337).
-spec decode7(
    fun((CNK, CNL, CNM, CNN, CNO, CNP, CNQ) -> CNR),
    fun((dynamic_()) -> {ok, CNK} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNL} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNM} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNN} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNO} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNP} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CNQ} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CNR} | {error, list(decode_error())}).
decode7(Constructor, T1, T2, T3, T4, T5, T6, T7) ->
    fun(X) -> case {T1(X), T2(X), T3(X), T4(X), T5(X), T6(X), T7(X)} of
            {{ok, A}, {ok, B}, {ok, C}, {ok, D}, {ok, E}, {ok, F}, {ok, G}} ->
                {ok, Constructor(A, B, C, D, E, F, G)};

            {A@1, B@1, C@1, D@1, E@1, F@1, G@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1),
                            all_errors(E@1),
                            all_errors(F@1),
                            all_errors(G@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1406).
-spec decode8(
    fun((COA, COB, COC, COD, COE, COF, COG, COH) -> COI),
    fun((dynamic_()) -> {ok, COA} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COB} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COC} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COD} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COE} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COF} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COG} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COH} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, COI} | {error, list(decode_error())}).
decode8(Constructor, T1, T2, T3, T4, T5, T6, T7, T8) ->
    fun(X) -> case {T1(X), T2(X), T3(X), T4(X), T5(X), T6(X), T7(X), T8(X)} of
            {{ok, A},
                {ok, B},
                {ok, C},
                {ok, D},
                {ok, E},
                {ok, F},
                {ok, G},
                {ok, H}} ->
                {ok, Constructor(A, B, C, D, E, F, G, H)};

            {A@1, B@1, C@1, D@1, E@1, F@1, G@1, H@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1),
                            all_errors(E@1),
                            all_errors(F@1),
                            all_errors(G@1),
                            all_errors(H@1)]
                    )}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/dynamic.gleam", 1479).
-spec decode9(
    fun((COS, COT, COU, COV, COW, COX, COY, COZ, CPA) -> CPB),
    fun((dynamic_()) -> {ok, COS} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COT} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COU} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COV} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COW} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COX} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COY} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, COZ} | {error, list(decode_error())}),
    fun((dynamic_()) -> {ok, CPA} | {error, list(decode_error())})
) -> fun((dynamic_()) -> {ok, CPB} | {error, list(decode_error())}).
decode9(Constructor, T1, T2, T3, T4, T5, T6, T7, T8, T9) ->
    fun(X) ->
        case {T1(X), T2(X), T3(X), T4(X), T5(X), T6(X), T7(X), T8(X), T9(X)} of
            {{ok, A},
                {ok, B},
                {ok, C},
                {ok, D},
                {ok, E},
                {ok, F},
                {ok, G},
                {ok, H},
                {ok, I}} ->
                {ok, Constructor(A, B, C, D, E, F, G, H, I)};

            {A@1, B@1, C@1, D@1, E@1, F@1, G@1, H@1, I@1} ->
                {error,
                    gleam@list:flatten(
                        [all_errors(A@1),
                            all_errors(B@1),
                            all_errors(C@1),
                            all_errors(D@1),
                            all_errors(E@1),
                            all_errors(F@1),
                            all_errors(G@1),
                            all_errors(H@1),
                            all_errors(I@1)]
                    )}
        end
    end.
