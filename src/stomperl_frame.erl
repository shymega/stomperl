-module(stomperl_frame).
-author("Dom Rodriguez <shymega@shymega.org.uk").

-export([new_frame/2]).

%% `[collate_opts/1,collate_opts/2]` based
%% on `concatenate_options` function in
%% from: https://github.com/igb/Erlang-STOMP-Client
%% Cheers, Ian (igb) !
-spec collate_opts(list()) -> list().
collate_opts([H | T]) ->
  {Key, Value} = H,
  lists:append(
    ["\n",
     Key,
     ": ",
     Value,
     collate_opts(T)]);
collate_opts([]) ->
  [].

-spec new_frame(string(), list()) -> list().
new_frame(CMD, Opts) ->
  lists:append([CMD,
                collate_opts(Opts),
                "\n\n"],
               [0]).
