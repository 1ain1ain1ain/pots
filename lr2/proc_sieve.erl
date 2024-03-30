-module(proc_sieve).
-export([generate/1, sieve/2, gen_print/1]).
-define(TIMEOUT, 1000000).

gen_print(MaxN) -> 
    Result = generate(MaxN),
    lists:foreach(fun (X) -> io:format("~w ", [X]) end, Result).

generate(MaxN) ->
        Pid = new_proc(),
        generate(Pid, 2, MaxN).

generate(Pid, End, End) ->
        Pid ! {done, self()},
        receive
                Res -> Res
        end;

generate(Pid, N, End) ->
        Pid ! N,    
        generate(Pid, N + 1, End).

new_proc() -> spawn(proc_sieve, sieve, [0, undefined]).

sieve(0, UndefinedPid) ->    
    receive 
        P -> sieve(P, UndefinedPid)
    after ?TIMEOUT ->
        io:format("time out in P=0~n")
    end; 

sieve(P, NextPid) when is_pid(NextPid) ->
    receive
        {done, From} ->
            NextPid ! {done, self()},
            receive 
                ResList -> 
                    From ! [P] ++ ResList
            end;
        N when N rem P == 0 ->
            sieve(P, NextPid);
        N when N rem P /= 0 ->
            NextPid ! N,
            sieve(P, NextPid)
    after ?TIMEOUT ->
        io:format("time out in is_pid clause P=~p~n", [P])
    end;

sieve(P, UndefinedNextPid) ->
    receive 
        {done, From} ->
            From ! [P];
        N when N rem P == 0 -> 
            sieve(P, UndefinedNextPid);
        N when N rem P /= 0 -> 
            Pid = new_proc(),
            Pid ! N,
            sieve(P, Pid)
    after ?TIMEOUT ->
        io:format("time out in no pid clause P=~p~n", [P])
    end.
