-module(stomperl_validator).
-author("Dom Rodriguez <shymega@shymega.org.uk>").

-include_lib("include/frame.hrl").

-export([format_header/2,
         normalise_version/1,
         is_valid_command/2]).

-spec valid_commands(float()) -> list().
valid_commands(1.0) ->
    [connected, message, receipt,
     error, connect, send, subscribe,
     unsubscribe, 'begin', commit,
     abort, ack, disconnect];
valid_commands(1.1) ->
	valid_commands(1.0) ++ [stomp, nack];
valid_commands(1.2) ->
    valid_commands(1.1);
valid_commands(_Version) ->
	valid_commands(?DEFAULT_STOMP_VERSION).

-spec is_valid_command(float(), atom()) -> boolean().
is_valid_command(Version, CMD) when is_float(Version), is_atom(CMD) ->
    lager:log(debug, "Asked if ~p is a valid STOMP command.", [CMD]),
    Commands = valid_commands(Version),
   lists:member(CMD, Commands);
is_valid_command(Version, CMD) when is_float(Version), is_binary(CMD) ->
    % LC means 'Lower-case'.
    CMD_LC = string:lowercase(CMD),
    % BEA means 'Binary -> Existing Atom'.
    CMD_BEA = erlang:binary_to_existing_atom(CMD_LC, utf8),
	is_valid_command(Version, CMD_BEA).

-spec format_header(binary(), binary()) -> map().
format_header(<<"content-length">>, Value) when is_binary(Value)->
    #{<<"content-length">> => erlang:binary_to_integer(Value)};
format_header(<<"version">>, Value) when is_binary(Value) ->
    #{<<"version">> => erlang:binary_to_float(Value)};
format_header(Key, Value) ->
    #{Key => Value}.

normalise_version(Versions) when length(Versions) == 0 ->
    ?DEFAULT_STOMP_VERSION;
normalise_version(Versions) when is_list(Versions), length(Versions) > 0 ->
    Versions;
normalise_version([]) ->
    ?DEFAULT_STOMP_VERSION;
normalise_version(Version) when is_float(Version) ->
    Version.
