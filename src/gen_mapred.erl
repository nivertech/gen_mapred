%%%-------------------------------------------------------------------
%%% File    : gen_mapred.erl
%%% Created : 07/05/2011
%%%
%%% @doc Generic Map/Reduce behavior in Erlang
%%%
%%% @todo document all API calls
%%%
%%% @author Zvi Avraham <zvi@nivertech.com>
%%%
%%% @copyright ZADATA Ltd, 2011-2013
%%% @license GPL, see file GPL-LICENSE.txt
%%% @end
%%%-----------------------------------------------------------------------------

-module(gen_mapred).

%% each callback function have 2 versions:
%% one generate output list with emitted Key/Values - may require a lot of memory for intermediate lists
%% the other more robust - send message for each emitted Key/Value

%% MinMappers..MaxMappers , MinReducers..MaxReducers

%% also need to support Hadoop's Streaming API

%% [ input reader -> map -> sort-and-shuffle -> combine ] ==>  [ reduce -> output writer ]
%% or maybe:
%% [ input reader -> map -> combine -> sort-and-shuffle ] ==>  [ reduce -> output writer ]

% TODO: is it good idea to restrict keys to "string"-like types?
-type key() :: atom() | binary() | iolist().

-type k1()::key().
-type v1()::term().

-type k2()::key().
-type v2()::term().

-type v3()::term().

-callback split(term()) -> [{k1(),v1()}].
% send {k1(),v1() or [{k1(),v1()}] to mapper (or compbiner): Pid ! {map_result, [{k1(),v1()}]).
-callback split(term(),pid()) -> ok. 
-callback output(term()) -> ok. 

-callback map_before() -> ok.
-callback map(k1(),v1()) -> [{k2(),v2()}]. 
-callback map(k1(),v1(),pid()) -> ok. 
-callback map_after() -> ok.

-callback combine_before() -> ok.
-callback combine([{k2(),v2()}]) -> [{k2(),[v2()]}]. 
-callback combine([{k2(),v2()}],pid()) -> ok. 
-callback combine_after() -> ok.

-callback reduce_before() -> ok.
-callback reduce(k2(),[v2()]) -> [v3()].
-callback reduce(k2(),[v2()],pid()) -> ok.
-callback reduce_after() -> ok.

-callback compare(k2(), k2()) -> -1|0|1.
-callback partition(k2(),v2(),NumReduceTasks::pos_integer()) -> non_neg_integer().
