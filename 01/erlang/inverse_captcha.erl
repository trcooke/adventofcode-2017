-module(inverse_captcha).

-export([part1/0, part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  [Hd|Tl] = get_nums(Fd, []),
  sum_nums([Hd] ++ Tl ++ [Hd], 0).
%%  sum_nums(Nums, 0).

get_nums(Fd, Acc) ->
  case io:get_chars(Fd, "", 1) of
    eof -> file:close(Fd), Acc;
    Ch -> case string:to_integer(Ch) of
            {_, no_integer} -> get_nums(Fd, Acc);
            {Num, []} -> get_nums(Fd, lists:append(Acc, [Num]))
          end
  end.

sum_nums([_|[]], Sum) ->
  Sum;
sum_nums([Hd|[Hd|Tl]], Sum) ->
  sum_nums([Hd] ++ Tl, Sum + Hd);
sum_nums([_|Tl], Sum) ->
  sum_nums(Tl, Sum).

part2() ->
  {ok, Fd} = file:open("input", [read]),
  Nums = get_nums(Fd, []),
  Len = length(Nums),
  sum_nums2(lists:split(Len div 2, Nums), 0) * 2.

sum_nums2({[],[]}, Sum) ->
  Sum;
sum_nums2({[X|Tl1],[X|Tl2]}, Sum) ->
  sum_nums2({Tl1,Tl2}, Sum + X);
sum_nums2({[_|Tl1],[_|Tl2]}, Sum) ->
  sum_nums2({Tl1,Tl2}, Sum).
