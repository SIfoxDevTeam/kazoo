%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2012-2018, 2600Hz
%%% @doc
%%% @author James Aimonetti
%%% @end
%%%-----------------------------------------------------------------------------
-module(hon_util_test).

-include_lib("eunit/include/eunit.hrl").

build_keys_test_() ->
    [?_assertEqual([1], hon_util:build_keys(<<"1">>))
    ,?_assertEqual([12, 1], hon_util:build_keys(<<"12">>))
    ,?_assertEqual([123, 12, 1], hon_util:build_keys(<<"123">>))
    ,?_assertEqual([123, 12, 1], hon_util:build_keys(<<"**123">>))
    ].
