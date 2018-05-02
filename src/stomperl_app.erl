%%%-------------------------------------------------------------------
%% @doc stomperl public API
%% @end
%%%-------------------------------------------------------------------

-module(stomperl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, connect/4]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    stomperl_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

-spec connect(string(), integer(), string(), string()) -> {ok, gen_tcp:socket()}.
connect(Host, Port,  Login, Passcode) ->
  % Create socket for TCP communication to STOMP server.
  {ok, Sock} = gen_tcp:connect(Host, Port,
                               [{active, false}]),
  ok = login(Sock, Login, Passcode),
  Response = receive_data(Sock, []),
  {ok, Response}.

-spec receive_data(gen_tcp:sock(), binary()) -> binary().
receive_data(Sock, SoFar) ->
  receive
    {tcp, Sock, Bin} ->
      receive_data(Sock, [Bin|SoFar]);
    {tcp_closed, Sock} ->
      list_to_binary(lists:reverse(SoFar))
  end.

-spec send(gen_tcp:sock(), string()) -> atom().
send(Sock, Frame) ->
  case gen_tcp:send(Sock, [Frame]) of
    ok -> ok;
    {error, Reason} -> {error, Reason}
  end.

-spec login(gen_tcp:sock(), string(), string()) -> atom().
login(Sock, Login, Passcode) ->
  FormatStr = "CONNECT\nlogin:~s\npasscode:~s\n\n~c",
  Args = [Login, Passcode, $\00],
  Frame = lists:flatten(
            io_lib:format(FormatStr,  Args)),
  send(Sock, Frame),
  ok.
