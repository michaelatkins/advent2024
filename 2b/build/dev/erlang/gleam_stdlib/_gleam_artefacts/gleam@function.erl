-module(gleam@function).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([compose/2, curry2/1, curry3/1, curry4/1, curry5/1, curry6/1, flip/1, identity/1, constant/1, tap/2, apply1/2, apply2/3, apply3/4]).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 2).
-spec compose(fun((DNS) -> DNT), fun((DNT) -> DNU)) -> fun((DNS) -> DNU).
compose(Fun1, Fun2) ->
    fun(A) -> Fun2(Fun1(A)) end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 7).
-spec curry2(fun((DNV, DNW) -> DNX)) -> fun((DNV) -> fun((DNW) -> DNX)).
curry2(Fun) ->
    fun(A) -> fun(B) -> Fun(A, B) end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 12).
-spec curry3(fun((DNZ, DOA, DOB) -> DOC)) -> fun((DNZ) -> fun((DOA) -> fun((DOB) -> DOC))).
curry3(Fun) ->
    fun(A) -> fun(B) -> fun(C) -> Fun(A, B, C) end end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 17).
-spec curry4(fun((DOE, DOF, DOG, DOH) -> DOI)) -> fun((DOE) -> fun((DOF) -> fun((DOG) -> fun((DOH) -> DOI)))).
curry4(Fun) ->
    fun(A) -> fun(B) -> fun(C) -> fun(D) -> Fun(A, B, C, D) end end end end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 22).
-spec curry5(fun((DOK, DOL, DOM, DON, DOO) -> DOP)) -> fun((DOK) -> fun((DOL) -> fun((DOM) -> fun((DON) -> fun((DOO) -> DOP))))).
curry5(Fun) ->
    fun(A) ->
        fun(B) ->
            fun(C) -> fun(D) -> fun(E) -> Fun(A, B, C, D, E) end end end
        end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 27).
-spec curry6(fun((DOR, DOS, DOT, DOU, DOV, DOW) -> DOX)) -> fun((DOR) -> fun((DOS) -> fun((DOT) -> fun((DOU) -> fun((DOV) -> fun((DOW) -> DOX)))))).
curry6(Fun) ->
    fun(A) ->
        fun(B) ->
            fun(C) ->
                fun(D) -> fun(E) -> fun(F) -> Fun(A, B, C, D, E, F) end end end
            end
        end
    end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 36).
-spec flip(fun((DOZ, DPA) -> DPB)) -> fun((DPA, DOZ) -> DPB).
flip(Fun) ->
    fun(B, A) -> Fun(A, B) end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 42).
-spec identity(DPC) -> DPC.
identity(X) ->
    X.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 47).
-spec constant(DPD) -> fun((any()) -> DPD).
constant(Value) ->
    fun(_) -> Value end.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 56).
-spec tap(DPF, fun((DPF) -> any())) -> DPF.
tap(Arg, Effect) ->
    Effect(Arg),
    Arg.

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 62).
-spec apply1(fun((DPH) -> DPI), DPH) -> DPI.
apply1(Fun, Arg1) ->
    Fun(Arg1).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 67).
-spec apply2(fun((DPJ, DPK) -> DPL), DPJ, DPK) -> DPL.
apply2(Fun, Arg1, Arg2) ->
    Fun(Arg1, Arg2).

-file("/Users/maatkn/Documents/Code/aoc/2024/2b/build/packages/gleam_stdlib/src/gleam/function.gleam", 72).
-spec apply3(fun((DPM, DPN, DPO) -> DPP), DPM, DPN, DPO) -> DPP.
apply3(Fun, Arg1, Arg2, Arg3) ->
    Fun(Arg1, Arg2, Arg3).
