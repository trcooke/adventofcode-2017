-module(spiral_memory).

-export([part1/0, part2/0]).

part1() ->
  spiral({0,0}, $E, 347991, []).

part2() ->
  0.

spiral(Loc, _, 1, _) ->
  distance(Loc);
spiral(Loc, Dir, Count, Breadcrumbs) ->
  case lists:member(nextLoc(left(Dir), Loc), Breadcrumbs) of
    true -> spiral(nextLoc(Dir, Loc), Dir, Count - 1, Breadcrumbs ++ [Loc]);
    false -> spiral(nextLoc(left(Dir), Loc), left(Dir), Count - 1, Breadcrumbs ++ [Loc])
  end.

nextLoc($N, {X,Y}) -> {X, Y + 1};
nextLoc($E, {X,Y}) -> {X + 1, Y};
nextLoc($W, {X,Y}) -> {X - 1, Y};
nextLoc($S, {X,Y}) -> {X, Y - 1}.

left($N) -> $W;
left($E) -> $N;
left($W) -> $S;
left($S) -> $E.

distance({X,Y}) ->
  abs(X) + abs(Y).
