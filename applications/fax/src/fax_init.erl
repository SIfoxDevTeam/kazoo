%%%-------------------------------------------------------------------
%%% @copyright (C) 2012-2016, 2600Hz
%%% @doc
%%%
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(fax_init).

-include("fax.hrl").

-export([start_link/0]).

%%--------------------------------------------------------------------
%% @public
%% @doc Starts the app for inclusion in a supervisor tree
%%--------------------------------------------------------------------
-spec start_link() -> startlink_ret().
start_link() ->
    _ = declare_exchanges(),
    Dispatch = cowboy_router:compile([
                                      %% :: {HostMatch, [{PathMatch, Handler, Opts}]}
                                      {'_', [{<<"/fax/[...]">>, 'fax_file_proxy', []}]}
                                     ]),

    Port = whapps_config:get_integer(?CONFIG_CAT, <<"port">>, 30950),
    Workers = whapps_config:get_integer(?CONFIG_CAT, <<"workers">>, 50),
    %% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
    cowboy:start_http('fax_file', Workers
                      ,[{'port', Port}]
                      ,[{'env', [{'dispatch', Dispatch}]}]
                     ),
    'ignore'.

%%--------------------------------------------------------------------
%% @private
%% @doc Ensures that all exchanges used are declared
%%--------------------------------------------------------------------
-spec declare_exchanges() -> 'ok'.
declare_exchanges() ->
    _ = wapi_fax:declare_exchanges(),
    _ = wapi_xmpp:declare_exchanges(),
    _ = wapi_conf:declare_exchanges(),
    _ = wapi_notifications:declare_exchanges(),
    _ = wapi_offnet_resource:declare_exchanges(),
    _ = wapi_call:declare_exchanges(),
    _ = wapi_dialplan:declare_exchanges(),
    wapi_self:declare_exchanges().
