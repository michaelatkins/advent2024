-module(gleam@iterator).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([unfold/2, repeatedly/1, repeat/1, from_list/1, transform/3, fold/3, run/1, to_list/1, step/1, take/2, drop/2, map/2, map2/3, append/2, flatten/1, concat/1, flat_map/2, filter/2, filter_map/2, cycle/1, find/2, find_map/2, index/1, iterate/2, take_while/2, drop_while/2, scan/3, zip/2, chunk/2, sized_chunk/2, intersperse/2, any/2, all/2, group/2, reduce/2, last/1, empty/0, once/1, range/2, single/1, interleave/2, fold_until/3, try_fold/3, first/1, at/2, length/1, each/2, yield/2]).
-export_type([action/1, iterator/1, step/2, chunk/2, sized_chunk/1]).

-type action(DQZ) :: stop | {continue, DQZ, fun(() -> action(DQZ))}.

-opaque iterator(DRA) :: {iterator, fun(() -> action(DRA))}.

-type step(DRB, DRC) :: {next, DRB, DRC} | done.

-type chunk(DRD, DRE) :: {another_by,
        list(DRD),
        DRE,
        DRD,
        fun(() -> action(DRD))} |
    {last_by, list(DRD)}.

-type sized_chunk(DRF) :: {another, list(DRF), fun(() -> action(DRF))} |
    {last, list(DRF)} |
    no_more.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 39).
-spec stop() -> action(any()).
stop() ->
    stop.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 75).
-spec unfold_loop(DRN, fun((DRN) -> step(DRO, DRN))) -> fun(() -> action(DRO)).
unfold_loop(Initial, F) ->
    fun() -> case F(Initial) of
            {next, X, Acc} ->
                {continue, X, unfold_loop(Acc, F)};

            done ->
                stop
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 65).
-spec unfold(DRI, fun((DRI) -> step(DRJ, DRI))) -> iterator(DRJ).
unfold(Initial, F) ->
    _pipe = Initial,
    _pipe@1 = unfold_loop(_pipe, F),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 98).
-spec repeatedly(fun(() -> DRS)) -> iterator(DRS).
repeatedly(F) ->
    unfold(nil, fun(_) -> {next, F(), nil} end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 114).
-spec repeat(DRU) -> iterator(DRU).
repeat(X) ->
    repeatedly(fun() -> X end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 129).
-spec from_list(list(DRW)) -> iterator(DRW).
from_list(List) ->
    Yield = fun(Acc) -> case Acc of
            [] ->
                done;

            [Head | Tail] ->
                {next, Head, Tail}
        end end,
    unfold(List, Yield).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 140).
-spec transform_loop(
    fun(() -> action(DRZ)),
    DSB,
    fun((DSB, DRZ) -> step(DSC, DSB))
) -> fun(() -> action(DSC)).
transform_loop(Continuation, State, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                case F(State, El) of
                    done ->
                        stop;

                    {next, Yield, Next_state} ->
                        {continue, Yield, transform_loop(Next, Next_state, F)}
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 176).
-spec transform(iterator(DSG), DSI, fun((DSI, DSG) -> step(DSJ, DSI))) -> iterator(DSJ).
transform(Iterator, Initial, F) ->
    _pipe = transform_loop(erlang:element(2, Iterator), Initial, F),
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 212).
-spec fold_loop(fun(() -> action(DSQ)), fun((DSS, DSQ) -> DSS), DSS) -> DSS.
fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        {continue, Elem, Next} ->
            fold_loop(Next, F, F(Accumulator, Elem));

        stop ->
            Accumulator
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 203).
-spec fold(iterator(DSN), DSP, fun((DSP, DSN) -> DSP)) -> DSP.
fold(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    fold_loop(_pipe, F, Initial).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 229).
-spec run(iterator(any())) -> nil.
run(Iterator) ->
    fold(Iterator, nil, fun(_, _) -> nil end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 248).
-spec to_list(iterator(DSV)) -> list(DSV).
to_list(Iterator) ->
    _pipe = Iterator,
    _pipe@1 = fold(_pipe, [], fun(Acc, E) -> [E | Acc] end),
    lists:reverse(_pipe@1).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 277).
-spec step(iterator(DSY)) -> step(DSY, iterator(DSY)).
step(Iterator) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            done;

        {continue, E, A} ->
            {next, E, {iterator, A}}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 311).
-spec take_loop(fun(() -> action(DTG)), integer()) -> fun(() -> action(DTG)).
take_loop(Continuation, Desired) ->
    fun() -> case Desired > 0 of
            false ->
                stop;

            true ->
                case Continuation() of
                    stop ->
                        stop;

                    {continue, E, Next} ->
                        {continue, E, take_loop(Next, Desired - 1)}
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 305).
-spec take(iterator(DTD), integer()) -> iterator(DTD).
take(Iterator, Desired) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = take_loop(_pipe, Desired),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 355).
-spec drop_loop(fun(() -> action(DTM)), integer()) -> action(DTM).
drop_loop(Continuation, Desired) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Desired > 0 of
                true ->
                    drop_loop(Next, Desired - 1);

                false ->
                    {continue, E, Next}
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 350).
-spec drop(iterator(DTJ), integer()) -> iterator(DTJ).
drop(Iterator, Desired) ->
    _pipe = fun() -> drop_loop(erlang:element(2, Iterator), Desired) end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 390).
-spec map_loop(fun(() -> action(DTT)), fun((DTT) -> DTV)) -> fun(() -> action(DTV)).
map_loop(Continuation, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, F(E), map_loop(Continuation@1, F)}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 384).
-spec map(iterator(DTP), fun((DTP) -> DTR)) -> iterator(DTR).
map(Iterator, F) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = map_loop(_pipe, F),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 432).
-spec map2_loop(
    fun(() -> action(DUD)),
    fun(() -> action(DUF)),
    fun((DUD, DUF) -> DUH)
) -> fun(() -> action(DUH)).
map2_loop(Continuation1, Continuation2, Fun) ->
    fun() -> case Continuation1() of
            stop ->
                stop;

            {continue, A, Next_a} ->
                case Continuation2() of
                    stop ->
                        stop;

                    {continue, B, Next_b} ->
                        {continue, Fun(A, B), map2_loop(Next_a, Next_b, Fun)}
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 423).
-spec map2(iterator(DTX), iterator(DTZ), fun((DTX, DTZ) -> DUB)) -> iterator(DUB).
map2(Iterator1, Iterator2, Fun) ->
    _pipe = map2_loop(
        erlang:element(2, Iterator1),
        erlang:element(2, Iterator2),
        Fun
    ),
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 470).
-spec append_loop(fun(() -> action(DUN)), fun(() -> action(DUN))) -> action(DUN).
append_loop(First, Second) ->
    case First() of
        {continue, E, First@1} ->
            {continue, E, fun() -> append_loop(First@1, Second) end};

        stop ->
            Second()
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 465).
-spec append(iterator(DUJ), iterator(DUJ)) -> iterator(DUJ).
append(First, Second) ->
    _pipe = fun() ->
        append_loop(erlang:element(2, First), erlang:element(2, Second))
    end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 498).
-spec flatten_loop(fun(() -> action(iterator(DUV)))) -> action(DUV).
flatten_loop(Flattened) ->
    case Flattened() of
        stop ->
            stop;

        {continue, It, Next_iterator} ->
            append_loop(
                erlang:element(2, It),
                fun() -> flatten_loop(Next_iterator) end
            )
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 493).
-spec flatten(iterator(iterator(DUR))) -> iterator(DUR).
flatten(Iterator) ->
    _pipe = fun() -> flatten_loop(erlang:element(2, Iterator)) end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 522).
-spec concat(list(iterator(DUZ))) -> iterator(DUZ).
concat(Iterators) ->
    flatten(from_list(Iterators)).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 545).
-spec flat_map(iterator(DVD), fun((DVD) -> iterator(DVF))) -> iterator(DVF).
flat_map(Iterator, F) ->
    _pipe = Iterator,
    _pipe@1 = map(_pipe, F),
    flatten(_pipe@1).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 582).
-spec filter_loop(fun(() -> action(DVL)), fun((DVL) -> boolean())) -> action(DVL).
filter_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Iterator} ->
            case Predicate(E) of
                true ->
                    {continue, E, fun() -> filter_loop(Iterator, Predicate) end};

                false ->
                    filter_loop(Iterator, Predicate)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 574).
-spec filter(iterator(DVI), fun((DVI) -> boolean())) -> iterator(DVI).
filter(Iterator, Predicate) ->
    _pipe = fun() -> filter_loop(erlang:element(2, Iterator), Predicate) end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 626).
-spec filter_map_loop(
    fun(() -> action(DVV)),
    fun((DVV) -> {ok, DVX} | {error, any()})
) -> action(DVX).
filter_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {continue, E@1, fun() -> filter_map_loop(Next, F) end};

                {error, _} ->
                    filter_map_loop(Next, F)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 618).
-spec filter_map(iterator(DVO), fun((DVO) -> {ok, DVQ} | {error, any()})) -> iterator(DVQ).
filter_map(Iterator, F) ->
    _pipe = fun() -> filter_map_loop(erlang:element(2, Iterator), F) end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 653).
-spec cycle(iterator(DWC)) -> iterator(DWC).
cycle(Iterator) ->
    _pipe = repeat(Iterator),
    flatten(_pipe).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 732).
-spec find_loop(fun(() -> action(DWK)), fun((DWK) -> boolean())) -> {ok, DWK} |
    {error, nil}.
find_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                true ->
                    {ok, E};

                false ->
                    find_loop(Next, F)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 724).
-spec find(iterator(DWG), fun((DWG) -> boolean())) -> {ok, DWG} | {error, nil}.
find(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_loop(_pipe, Is_desired).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 778).
-spec find_map_loop(
    fun(() -> action(DWW)),
    fun((DWW) -> {ok, DWY} | {error, any()})
) -> {ok, DWY} | {error, nil}.
find_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {ok, E@1};

                {error, _} ->
                    find_map_loop(Next, F)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 770).
-spec find_map(iterator(DWO), fun((DWO) -> {ok, DWQ} | {error, any()})) -> {ok,
        DWQ} |
    {error, nil}.
find_map(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_map_loop(_pipe, Is_desired).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 808).
-spec index_loop(fun(() -> action(DXH)), integer()) -> fun(() -> action({DXH,
    integer()})).
index_loop(Continuation, Next) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, {E, Next}, index_loop(Continuation@1, Next + 1)}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 802).
-spec index(iterator(DXE)) -> iterator({DXE, integer()}).
index(Iterator) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = index_loop(_pipe, 0),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 831).
-spec iterate(DXK, fun((DXK) -> DXK)) -> iterator(DXK).
iterate(Initial, F) ->
    unfold(Initial, fun(Element) -> {next, Element, F(Element)} end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 859).
-spec take_while_loop(fun(() -> action(DXP)), fun((DXP) -> boolean())) -> fun(() -> action(DXP)).
take_while_loop(Continuation, Predicate) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Next} ->
                case Predicate(E) of
                    false ->
                        stop;

                    true ->
                        {continue, E, take_while_loop(Next, Predicate)}
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 850).
-spec take_while(iterator(DXM), fun((DXM) -> boolean())) -> iterator(DXM).
take_while(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = take_while_loop(_pipe, Predicate),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 896).
-spec drop_while_loop(fun(() -> action(DXV)), fun((DXV) -> boolean())) -> action(DXV).
drop_while_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Predicate(E) of
                false ->
                    {continue, E, Next};

                true ->
                    drop_while_loop(Next, Predicate)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 888).
-spec drop_while(iterator(DXS), fun((DXS) -> boolean())) -> iterator(DXS).
drop_while(Iterator, Predicate) ->
    _pipe = fun() -> drop_while_loop(erlang:element(2, Iterator), Predicate) end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 935).
-spec scan_loop(fun(() -> action(DYC)), fun((DYE, DYC) -> DYE), DYE) -> fun(() -> action(DYE)).
scan_loop(Continuation, F, Accumulator) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                Accumulated = F(Accumulator, El),
                {continue, Accumulated, scan_loop(Next, F, Accumulated)}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 925).
-spec scan(iterator(DXY), DYA, fun((DYA, DXY) -> DYA)) -> iterator(DYA).
scan(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = scan_loop(_pipe, F, Initial),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 969).
-spec zip_loop(fun(() -> action(DYL)), fun(() -> action(DYN))) -> fun(() -> action({DYL,
    DYN})).
zip_loop(Left, Right) ->
    fun() -> case Left() of
            stop ->
                stop;

            {continue, El_left, Next_left} ->
                case Right() of
                    stop ->
                        stop;

                    {continue, El_right, Next_right} ->
                        {continue,
                            {El_left, El_right},
                            zip_loop(Next_left, Next_right)}
                end
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 964).
-spec zip(iterator(DYG), iterator(DYI)) -> iterator({DYG, DYI}).
zip(Left, Right) ->
    _pipe = zip_loop(erlang:element(2, Left), erlang:element(2, Right)),
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1031).
-spec next_chunk(fun(() -> action(DZA)), fun((DZA) -> DZC), DZC, list(DZA)) -> chunk(DZA, DZC).
next_chunk(Continuation, F, Previous_key, Current_chunk) ->
    case Continuation() of
        stop ->
            {last_by, lists:reverse(Current_chunk)};

        {continue, E, Next} ->
            Key = F(E),
            case Key =:= Previous_key of
                true ->
                    next_chunk(Next, F, Key, [E | Current_chunk]);

                false ->
                    {another_by, lists:reverse(Current_chunk), Key, E, Next}
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1018).
-spec chunk_loop(fun(() -> action(DYV)), fun((DYV) -> DYX), DYX, DYV) -> action(list(DYV)).
chunk_loop(Continuation, F, Previous_key, Previous_element) ->
    case next_chunk(Continuation, F, Previous_key, [Previous_element]) of
        {last_by, Chunk} ->
            {continue, Chunk, fun stop/0};

        {another_by, Chunk@1, Key, El, Next} ->
            {continue, Chunk@1, fun() -> chunk_loop(Next, F, Key, El) end}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1005).
-spec chunk(iterator(DYQ), fun((DYQ) -> any())) -> iterator(list(DYQ)).
chunk(Iterator, F) ->
    _pipe = fun() -> case (erlang:element(2, Iterator))() of
            stop ->
                stop;

            {continue, E, Next} ->
                chunk_loop(Next, F, F(E), E)
        end end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1103).
-spec next_sized_chunk(fun(() -> action(DZO)), integer(), list(DZO)) -> sized_chunk(DZO).
next_sized_chunk(Continuation, Left, Current_chunk) ->
    case Continuation() of
        stop ->
            case Current_chunk of
                [] ->
                    no_more;

                Remaining ->
                    {last, lists:reverse(Remaining)}
            end;

        {continue, E, Next} ->
            Chunk = [E | Current_chunk],
            case Left > 1 of
                false ->
                    {another, lists:reverse(Chunk), Next};

                true ->
                    next_sized_chunk(Next, Left - 1, Chunk)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1082).
-spec sized_chunk_loop(fun(() -> action(DZK)), integer()) -> fun(() -> action(list(DZK))).
sized_chunk_loop(Continuation, Count) ->
    fun() -> case next_sized_chunk(Continuation, Count, []) of
            no_more ->
                stop;

            {last, Chunk} ->
                {continue, Chunk, fun stop/0};

            {another, Chunk@1, Next_element} ->
                {continue, Chunk@1, sized_chunk_loop(Next_element, Count)}
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1073).
-spec sized_chunk(iterator(DZG), integer()) -> iterator(list(DZG)).
sized_chunk(Iterator, Count) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = sized_chunk_loop(_pipe, Count),
    {iterator, _pipe@1}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1164).
-spec intersperse_loop(fun(() -> action(DZV)), DZV) -> action(DZV).
intersperse_loop(Continuation, Separator) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            Next_interspersed = fun() -> intersperse_loop(Next, Separator) end,
            {continue, Separator, fun() -> {continue, E, Next_interspersed} end}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1151).
-spec intersperse(iterator(DZS), DZS) -> iterator(DZS).
intersperse(Iterator, Elem) ->
    _pipe = fun() -> case (erlang:element(2, Iterator))() of
            stop ->
                stop;

            {continue, E, Next} ->
                {continue, E, fun() -> intersperse_loop(Next, Elem) end}
        end end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1213).
-spec any_loop(fun(() -> action(EAA)), fun((EAA) -> boolean())) -> boolean().
any_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            false;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    true;

                false ->
                    any_loop(Next, Predicate)
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1205).
-spec any(iterator(DZY), fun((DZY) -> boolean())) -> boolean().
any(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    any_loop(_pipe, Predicate).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1263).
-spec all_loop(fun(() -> action(EAE)), fun((EAE) -> boolean())) -> boolean().
all_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            true;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    all_loop(Next, Predicate);

                false ->
                    false
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1255).
-spec all(iterator(EAC), fun((EAC) -> boolean())) -> boolean().
all(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    all_loop(_pipe, Predicate).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1309).
-spec update_group_with(EAU) -> fun((gleam@option:option(list(EAU))) -> list(EAU)).
update_group_with(El) ->
    fun(Maybe_group) -> case Maybe_group of
            {some, Group} ->
                [El | Group];

            none ->
                [El]
        end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1300).
-spec group_updater(fun((EAM) -> EAN)) -> fun((gleam@dict:dict(EAN, list(EAM)), EAM) -> gleam@dict:dict(EAN, list(EAM))).
group_updater(F) ->
    fun(Groups, Elem) -> _pipe = Groups,
        gleam@dict:upsert(_pipe, F(Elem), update_group_with(Elem)) end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1291).
-spec group(iterator(EAG), fun((EAG) -> EAI)) -> gleam@dict:dict(EAI, list(EAG)).
group(Iterator, Key) ->
    _pipe = Iterator,
    _pipe@1 = fold(_pipe, maps:new(), group_updater(Key)),
    gleam@dict:map_values(_pipe@1, fun(_, Group) -> lists:reverse(Group) end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1340).
-spec reduce(iterator(EAY), fun((EAY, EAY) -> EAY)) -> {ok, EAY} | {error, nil}.
reduce(Iterator, F) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            _pipe = fold_loop(Next, F, E),
            {ok, _pipe}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1371).
-spec last(iterator(EBC)) -> {ok, EBC} | {error, nil}.
last(Iterator) ->
    _pipe = Iterator,
    reduce(_pipe, fun(_, Elem) -> Elem end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1386).
-spec empty() -> iterator(any()).
empty() ->
    {iterator, fun stop/0}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1400).
-spec once(fun(() -> EBI)) -> iterator(EBI).
once(F) ->
    _pipe = fun() -> {continue, F(), fun stop/0} end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 679).
-spec range(integer(), integer()) -> iterator(integer()).
range(Start, Stop) ->
    case gleam@int:compare(Start, Stop) of
        eq ->
            once(fun() -> Start end);

        gt ->
            unfold(Start, fun(Current) -> case Current < Stop of
                        false ->
                            {next, Current, Current - 1};

                        true ->
                            done
                    end end);

        lt ->
            unfold(Start, fun(Current@1) -> case Current@1 > Stop of
                        false ->
                            {next, Current@1, Current@1 + 1};

                        true ->
                            done
                    end end)
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1415).
-spec single(EBK) -> iterator(EBK).
single(Elem) ->
    once(fun() -> Elem end).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1447).
-spec interleave_loop(fun(() -> action(EBQ)), fun(() -> action(EBQ))) -> action(EBQ).
interleave_loop(Current, Next) ->
    case Current() of
        stop ->
            Next();

        {continue, E, Next_other} ->
            {continue, E, fun() -> interleave_loop(Next, Next_other) end}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1439).
-spec interleave(iterator(EBM), iterator(EBM)) -> iterator(EBM).
interleave(Left, Right) ->
    _pipe = fun() ->
        interleave_loop(erlang:element(2, Left), erlang:element(2, Right))
    end,
    {iterator, _pipe}.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1492).
-spec fold_until_loop(
    fun(() -> action(EBY)),
    fun((ECA, EBY) -> gleam@list:continue_or_stop(ECA)),
    ECA
) -> ECA.
fold_until_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            Accumulator;

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {continue, Accumulator@1} ->
                    fold_until_loop(Next, F, Accumulator@1);

                {stop, Accumulator@2} ->
                    Accumulator@2
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1483).
-spec fold_until(
    iterator(EBU),
    EBW,
    fun((EBW, EBU) -> gleam@list:continue_or_stop(EBW))
) -> EBW.
fold_until(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    fold_until_loop(_pipe, F, Initial).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1536).
-spec try_fold_loop(
    fun(() -> action(ECK)),
    fun((ECM, ECK) -> {ok, ECM} | {error, ECN}),
    ECM
) -> {ok, ECM} | {error, ECN}.
try_fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            {ok, Accumulator};

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {ok, Result} ->
                    try_fold_loop(Next, F, Result);

                {error, _} = Error ->
                    Error
            end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1527).
-spec try_fold(iterator(ECC), ECE, fun((ECE, ECC) -> {ok, ECE} | {error, ECF})) -> {ok,
        ECE} |
    {error, ECF}.
try_fold(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    try_fold_loop(_pipe, F, Initial).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1567).
-spec first(iterator(ECS)) -> {ok, ECS} | {error, nil}.
first(Iterator) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            {error, nil};

        {continue, E, _} ->
            {ok, E}
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1598).
-spec at(iterator(ECW), integer()) -> {ok, ECW} | {error, nil}.
at(Iterator, Index) ->
    _pipe = Iterator,
    _pipe@1 = drop(_pipe, Index),
    first(_pipe@1).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1627).
-spec length_loop(fun(() -> action(any())), integer()) -> integer().
length_loop(Continuation, Length) ->
    case Continuation() of
        stop ->
            Length;

        {continue, _, Next} ->
            length_loop(Next, Length + 1)
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1622).
-spec length(iterator(any())) -> integer().
length(Iterator) ->
    _pipe = erlang:element(2, Iterator),
    length_loop(_pipe, 0).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1652).
-spec each(iterator(EDE), fun((EDE) -> any())) -> nil.
each(Iterator, F) ->
    _pipe = Iterator,
    _pipe@1 = map(_pipe, F),
    run(_pipe@1).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/iterator.gleam", 1678).
-spec yield(EDH, fun(() -> iterator(EDH))) -> iterator(EDH).
yield(Element, Next) ->
    {iterator,
        fun() ->
            {continue, Element, fun() -> (erlang:element(2, Next()))() end}
        end}.
