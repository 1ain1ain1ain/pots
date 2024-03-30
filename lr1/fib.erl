-module(fib).
-export([fib_p/1, fib_g/1, tail_fib/1]).

% Часть 1. Функция Фибоначчи
% 1.1 Без хвостовой рекурсии
fib_p(N) ->
  if
    N == 0 -> 0;
    N == 1 -> 1;
    true -> fib_p(N - 1) + fib_p(N - 2)
  end.

% 1.2 Без хвостовой рекурсии, используя ветки when
fib_g(N) when N > 1 ->
  fib_g(N - 1) + fib_g(N - 2);
fib_g(0) -> 0;
fib_g(1) -> 1.

% 1.3 С хвостовой рекурсией
tail_fib(N) -> tail_fib_helper(N, 1, 0).
tail_fib_helper(0, _, Result) -> Result;
tail_fib_helper(N, X, Result) ->
  tail_fib_helper(N - 1, X + Result, X).
