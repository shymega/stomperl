-module(stomperl_frame).
-author("Dom Rodriguez <shymega@shymega.org.uk").

-include_lib("include/frame.hrl").

-export([new_frame/2]).

%% `[collate_opts/1,collate_opts/2]` based
%% on `concatenate_options` function in
%% from: https://github.com/igb/Erlang-STOMP-Client
%% Kudos to igb.
-spec collate_opts(list()) -> list().
collate_opts([H | T]) ->
  {Key, Value} = H,
  lists:append(
    ["\n",
     Key,
     ": ",
     Value,
     collate_opts(T)]);
collate_opts([]) -> [].

-spec new_frame(string(), list()) -> list().
new_frame(CMD, Opts) ->
    lager:debug("Creating a STOMP frame on request, cmd: ~p", [CMD]),

    % `F` is a record, an internal representation of the frame.  Final
    % processing of the frame will turn it into a binary term with
    % correct delimiter characters, etc.
    F = #frame{
           cmd=CMD,
           headers=collate_opts(Opts),
           content_type = <<"">>,
           body = <<"">>},
    {ok, F}.
