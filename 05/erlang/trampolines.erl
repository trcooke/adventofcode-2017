-module(trampolines).

-export([part1/0,part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = lists:map(fun(X) -> toNum(string:trim(X)) end, get_lines(Fd, [])),
  Lines,
  makeMove(Lines, 1, 0).

part2() -> 
  {ok, Fd} = file:open("input", [read]),
  Lines = lists:map(fun(X) -> toNum(string:trim(X)) end, get_lines(Fd, [])),
  Lines,
  makeMove2(Lines, 1, 0).

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

toNum(Str) ->
  case string:to_integer(Str) of
    {_, no_integer} -> 0;
    {Num, []} -> Num
  end.

makeMove(Instructions, Position, Steps) ->
  case (Position < 1) or (Position > length(Instructions)) of
    true -> Steps;
    false -> Elem = lists:nth(Position, Instructions), makeMove(lists:sublist(Instructions, Position - 1) ++ [Elem + 1] ++ lists:nthtail(Position, Instructions), Position + Elem, Steps + 1)
  end.

makeMove2(Instructions, Position, Steps) ->
  case (Position < 1) or (Position > length(Instructions)) of
    true -> Steps;
    false -> Elem = lists:nth(Position, Instructions), makeMove2(lists:sublist(Instructions, Position - 1) ++ [if Elem >= 3 -> Elem - 1; true -> Elem + 1 end] ++ lists:nthtail(Position, Instructions), Position + Elem, Steps + 1)
  end.
