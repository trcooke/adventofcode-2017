-module(corruption_checksum).

-export([part1/0, part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = get_lines(Fd, []),
  process_lines(Lines, 0).

part2() ->
  0.

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

process_lines([], Acc) ->
  Acc;
process_lines([Hd|Tl], Acc) ->
  Tokens = string:tokens(Hd, "\t\n"),
  Nums = lists:map(fun(X) -> {Num,_} = string:to_integer(X), Num end, Tokens),
  process_lines(Tl, Acc + (lists:max(Nums) - lists:min(Nums))).
