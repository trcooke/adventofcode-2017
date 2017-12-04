-module(spiral_memory).

-export([part1/0, part2/0]).

part1() ->
  spiral({0,0}, $E, 347991, []).

part2() ->
  spiral2({0,0}, 1, $E, 347991, #{{0,0} => 1}).

spiral(Loc, _, 1, _) ->
  distance(Loc);
spiral(Loc, Dir, Count, Breadcrumbs) ->
  case lists:member(nextLoc(left(Dir), Loc), Breadcrumbs) of
    true -> spiral(nextLoc(Dir, Loc), Dir, Count - 1, Breadcrumbs ++ [Loc]);
    false -> spiral(nextLoc(left(Dir), Loc), left(Dir), Count - 1, Breadcrumbs ++ [Loc])
  end.

spiral2(Loc, Val, Dir, Target, Breadcrumbs) ->
  case Val > Target of
    true -> Val;
    false -> 
      {NewLoc, NewDir} = newLoc(Loc, Dir, Breadcrumbs),
      NewBreadcrumbs = maps:put(Loc, Val, Breadcrumbs),
      NewLocVal = sum_of_surroundings(NewLoc, NewBreadcrumbs),
      spiral2(NewLoc, NewLocVal, NewDir, Target,  NewBreadcrumbs)
  end.

newLoc(Loc, Dir, Breadcrumbs) ->
  case maps:is_key(nextLoc(left(Dir), Loc), Breadcrumbs) of
    true -> {nextLoc(Dir, Loc), Dir};
    false -> {nextLoc(left(Dir), Loc), left(Dir)}
  end.

sum_of_surroundings({X,Y}, Breadcrumbs) ->
  maps:get({X-1,Y-1}, Breadcrumbs, 0) +
  maps:get({X-1,Y}, Breadcrumbs, 0) +
  maps:get({X-1,Y+1}, Breadcrumbs, 0) +
  maps:get({X,Y-1}, Breadcrumbs, 0) +
  maps:get({X,Y+1}, Breadcrumbs, 0) +
  maps:get({X+1,Y-1}, Breadcrumbs, 0) +
  maps:get({X+1,Y}, Breadcrumbs, 0) +
  maps:get({X+1,Y+1}, Breadcrumbs, 0).

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
