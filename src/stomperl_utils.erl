-module(stomperl_utils).
-author("Dom Rodriguez <shymega@shymega.org.uk>").
-include_lib("include/frame.hrl").

-export([list_del_empty_bin/1,
         trim_bin_list/1,
         split_header/1,
         split_headers/1]).

list_del_empty_bin(L) when is_list(L) ->
    lists:filter(fun (E) ->
                         E /= <<>>
                 end,
                 L).

split_headers(Bin) when is_binary(Bin) ->
    binary:split(Bin, <<"\n">>, [global]).

split_header(H) when is_binary(H)->
    re:split(H, ?KV_RE, [{return, binary}]).

trim_bin(Bin) when is_binary(Bin) ->
    re:replace(Bin, "^\\s+|\\s+$", "",
               [{return, binary}, global]);
trim_bin(E) ->
    E.

trim_bin_list(L) when is_list(L) ->
    lists:map(fun(E) -> trim_bin(E) end, L).
