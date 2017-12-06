-module(reallocation).

-export([part1/0,part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  [Hd|_] = get_lines(Fd, []),
  Tokens = string:tokens(Hd, "\t\n"),
  Nums = lists:map(fun(X) -> {Num,_} = string:to_integer(X), Num end, Tokens),
  process(Nums, 0, []).

part2() ->
  {ok, Fd} = file:open("input", [read]),
  [Hd|_] = get_lines(Fd, []),
  Tokens = string:tokens(Hd, "\t\n"),
  Nums = lists:map(fun(X) -> {Num,_} = string:to_integer(X), Num end, Tokens),
  process2(Nums, 0, []).

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

process(Nums, Count, History) ->
  case lists:member(Nums, History) of
    true -> Count;
    false -> process(nextNums(Nums), Count + 1, History ++ [Nums])
  end.

process2(Nums, Count, History) ->
  case lists:member(Nums, History) of
    true -> length(History) - index_of(Nums, History) + 1;
    false -> process2(nextNums(Nums), Count + 1, History ++ [Nums])
  end.

nextNums(Nums) ->
  Max = lists:max(Nums),
  Idx = index_of(Max, Nums),
  Len = length(Nums),
  distribute(lists:sublist(Nums, Idx - 1) ++ [0] ++ lists:nthtail(Idx, Nums), (Idx rem Len) + 1, Len, Max).

distribute(Nums, _, _, 0) ->
  Nums;
distribute(Nums, Idx, Len, Cnt) ->
  distribute(lists:sublist(Nums, Idx - 1) ++ [lists:nth(Idx, Nums) + 1] ++ lists:nthtail(Idx, Nums), (Idx rem Len) + 1, Len, Cnt - 1).

index_of(Item, List) ->
  index_of(Item, List, 1).

index_of(_, [], _) ->
  not_found;
index_of(Item, [Item|_], Index) ->
  Index;
index_of(Item, [_|Tl], Index) ->
  index_of(Item, Tl, Index + 1).
