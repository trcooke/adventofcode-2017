-module(high_entropy_passphrases).

-export([part1/0, part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = get_lines(Fd, []),
  process_lines(Lines).

part2() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = get_lines(Fd, []),
  process_lines2(Lines).

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

process_lines(Lines) ->
  process_lines_iter(Lines, 0).

process_lines_iter([], Acc) ->
  Acc;
process_lines_iter([Hd|Tl], Acc) ->
  Tokens = string:tokens(Hd, " \n"),
  case dups(Tokens) of
    true -> process_lines_iter(Tl, Acc);
    false -> process_lines_iter(Tl, Acc + 1)
  end.

dups(Tokens) ->
  dups_iter(Tokens, []).

dups_iter([], _) ->
  false;
dups_iter([Hd|Tl], UsedWords) ->
  case lists:member(lists:sort(Hd), UsedWords) of
    true -> true;
    false -> dups_iter(Tl, UsedWords ++ [lists:sort(Hd)])
  end.

process_lines2(Lines) ->
  process_lines_iter2(Lines, 0).

process_lines_iter2([], Acc) ->
  Acc;
process_lines_iter2([Hd|Tl], Acc) ->
  Tokens = string:tokens(Hd, " \n"),
  case dups2(Tokens) of
    true -> process_lines_iter2(Tl, Acc);
    false -> process_lines_iter2(Tl, Acc + 1)
  end.

dups2(Tokens) ->
  dups_iter2(Tokens, []).

dups_iter2([], _) ->
  false;
dups_iter2([Hd|Tl], UsedWords) ->
  case lists:member(lists:sort(Hd), UsedWords) of
    true -> true;
    false -> dups_iter2(Tl, UsedWords ++ [lists:sort(Hd)])
  end.
