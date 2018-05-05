-module(stomp_impl_test).
-export([impl/0]).

impl() ->
  F = ["CONNECT",
           "\naccept-version: 1.2\nhost: stomp.shymega.org.uk","\n\n",
           0],
  % find the command string
  % obviously the first element in the list is the COMMAND.

  % (obviously. its really not obvious, and i'm really NOT doing this
  % code in the `erlang` way, so sorry)
  CMD = lists:nth(1, F),

  % trim CMD from frame, keep iterating.
  F2 = lists:delete(CMD, F),

  io:format("Frame: ~p~n", [F]),
  io:format("CMD: ~p~n", [CMD]),
  io:format("Final iteration: ~p~n", [F2]).

