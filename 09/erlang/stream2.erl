-module(stream2).

-export([solve/0]).

solve() ->
  {ok, Fd} = file:open("input", [read]),
  [Line|_] = get_lines(Fd, []),
  garbage_count(string:trim(Line)).

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

garbage_count(Stream) ->
  group(Stream, 0).

group([], Count) ->
  Count;
group([${|Tl], Count) ->
  group(Tl, Count);
group([$}|Tl], Count) ->
  group(Tl,  Count);
group([$<|Tl], Count) ->
  garbage(Tl, Count);
group([_|Tl], Count) ->
  group(Tl, Count).

garbage([], Count) ->
  Count;
garbage([$>|Tl], Count) ->
  group(Tl, Count);
garbage([$!,_|Tl], Count) ->
  garbage(Tl, Count);
garbage([_|Tl], Count) ->
  garbage(Tl, Count + 1).
