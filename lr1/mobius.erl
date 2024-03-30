-module(mobius).
-export([is_prime/1, prime_factors/1, is_square_multiple/1, find_square_multiples/2]).

% Часть 2. Функция Мёбиуса
% 2.1 Проверка простого числа
is_prime(N) -> is_prime_helper(N, 2).
is_prime_helper(N, Divisor) when
  Divisor * Divisor > N -> true;
is_prime_helper(N, Divisor) ->
  if
    N rem Divisor == 0 -> false;
    true -> is_prime_helper(N, Divisor + 1)
  end.

% 2.2 Список простых сомножителей
prime_factors(N) -> prime_factors_helper(N, 2, [1], true).
prime_factors_helper(N, _, [Head|Tail], _) when
  N == 1 -> [Head|Tail];
prime_factors_helper(N, Divisor, [Head|Tail], true) ->
  if
    N rem Divisor == 0 ->
      prime_factors_helper(N div Divisor, Divisor, [Divisor, Head|Tail], is_prime(Divisor));
    true -> prime_factors_helper(N, Divisor + 1, [Head|Tail], is_prime(Divisor + 1))
  end;
prime_factors_helper(N, Divisor, [Head|Tail], false) ->
  prime_factors_helper(N, Divisor + 1, [Head|Tail], is_prime(Divisor + 1)).

% 2.3 Деление на квадрат простого числа
is_square_multiple(N) -> square_helper(lists:sort(prime_factors(N))).
square_helper([_]) -> false;
square_helper([X1, X2|Tail]) ->
  if
    X1 == X2 -> true;
    true -> square_helper([X2|Tail])
  end.

% 2.4 Нахождение последовательности
find_square_multiples(Count, MaxN) -> helper(Count, 0, 2, MaxN).
helper(Count, Increment, Number, _) when Count == Increment -> Number - Count;
helper(_, _, Number, MaxN) when Number > MaxN -> fail;
helper(Count, Increment, Number, MaxN) ->
  case is_square_multiple(Number) of
    false -> helper(Count, 0, Number + 1, MaxN);
    true -> helper(Count, Increment + 1, Number + 1, MaxN)
  end.
