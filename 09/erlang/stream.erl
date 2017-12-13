-module(stream).

-export([part1/0,part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  [Line|_] = get_lines(Fd, []),
  group_score(string:trim(Line)).

part2() ->
  {ok, Fd} = file:open("input", [read]),
  [Line|_] = get_lines(Fd, []),
  Line.

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

group_score(Stream) ->
  group(Stream, 0, 0).

group([], _, Score) ->
  Score;
group([${|Tl], GrpStack, Score) ->
  group(Tl, GrpStack + 1, Score);
group([$}|Tl], GrpStack, Score) ->
  group(Tl, GrpStack - 1, Score + GrpStack);
group([$<|Tl], GrpStack, Score) ->
  garbage(Tl, GrpStack, Score);
group([_|Tl], GrpStack, Score) ->
  group(Tl, GrpStack, Score).

garbage([], _, Score) ->
  Score;
garbage([$>|Tl], GrpStack, Score) ->
  group(Tl, GrpStack, Score);
garbage([$!,_|Tl], GrpStack, Score) ->
  garbage(Tl, GrpStack, Score);
garbage([_|Tl], GrpStack, Score) ->
  garbage(Tl, GrpStack, Score).
