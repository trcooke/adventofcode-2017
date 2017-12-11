-module(registers).

-export([part1/0,part2/0]).

part1() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = get_lines(Fd, []),
  process_lines(Lines).

part2() ->
  {ok, Fd} = file:open("input", [read]),
  Lines = get_lines(Fd, []),
  process_lines2(Lines).

process_lines(Lines) ->
  Register = load_register(Lines, maps:new()),
  lists:max(maps:values(Register)).

process_lines2(Lines) ->
  load_register(Lines, maps:new(), 0).

load_register([], Reg) ->
  Reg;
load_register([Hd|Tl], Reg) ->
  InsAndCond = string:split(Hd, "if"),
  Instruction = string:tokens(lists:nth(1, InsAndCond), " \n"),
  Condition = string:tokens(lists:nth(2, InsAndCond), " \n"),
  case condition(Condition, Reg) of
    true -> load_register(Tl, instruction(Instruction, Reg));
    false -> load_register(Tl, Reg)
  end.

load_register([], _, Max) ->
  Max;
load_register([Hd|Tl], Reg, Max) ->
  InsAndCond = string:split(Hd, "if"),
  Instruction = string:tokens(lists:nth(1, InsAndCond), " \n"),
  Condition = string:tokens(lists:nth(2, InsAndCond), " \n"),
  case condition(Condition, Reg) of
    true -> {NewReg, NewMax} = instruction(Instruction, Reg, Max), load_register(Tl, NewReg, NewMax);
    false -> load_register(Tl, Reg, Max)
  end.

condition([Register, Condition, Value], Reg) ->
  {Val,_} = string:to_integer(Value),
  doCond([Register, Condition, Val], Reg).
doCond([Register, ">", Value], Reg) ->
  maps:get(Register, Reg, 0) > Value;
doCond([Register, "<", Value], Reg) ->
  maps:get(Register, Reg, 0) < Value;
doCond([Register, ">=", Value], Reg) ->
  maps:get(Register, Reg, 0) >= Value;
doCond([Register, "<=", Value], Reg) ->
  maps:get(Register, Reg, 0) =< Value;
doCond([Register, "==", Value], Reg) ->
  maps:get(Register, Reg, 0) == Value;
doCond([Register, "!=", Value], Reg) ->
  maps:get(Register, Reg, 0) /= Value.
  
instruction([Register, Instruction, Value], Reg) ->
  {Val,_} = string:to_integer(Value),
  doIns([Register, Instruction, Val], Reg).
doIns([Register, "inc", Value], Reg) ->
  maps:put(Register, maps:get(Register, Reg, 0) + Value, Reg);
doIns([Register, "dec", Value], Reg) ->
  maps:put(Register, maps:get(Register, Reg, 0) - Value, Reg).

instruction([Register, Instruction, Value], Reg, Max) ->
  {Val,_} = string:to_integer(Value),
  doIns([Register, Instruction, Val], Reg, Max).
doIns([Register, "inc", Value], Reg, Max) ->
  NewVal = maps:get(Register, Reg, 0) + Value,
  case NewVal > Max of
    true -> {maps:put(Register, NewVal, Reg), NewVal};
    false -> {maps:put(Register, NewVal, Reg), Max}
  end;
doIns([Register, "dec", Value], Reg, Max) ->
  NewVal = maps:get(Register, Reg, 0) - Value,
  case NewVal > Max of
    true -> {maps:put(Register, NewVal, Reg), NewVal};
    false -> {maps:put(Register, NewVal, Reg), Max}
  end.

get_lines(Fd, Acc) ->
  case io:get_line(Fd, "") of
    eof -> file:close(Fd), Acc;
    Line -> get_lines(Fd, lists:append(Acc, [Line]))
  end.

