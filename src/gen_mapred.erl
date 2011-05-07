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
%%% @copyright Nivertech (Nywhere Tech Ltd), 2011
%%% @license GPL, see file GPL-LICENSE.txt
%%% @end
%%%-----------------------------------------------------------------------------

-module(gen_mapred).

-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [
     {map,      2},
     {combine,  1},
     {reduce,   2},
     {compare,  2},
     {partition,3}
    ];

behaviour_info(_Other) ->
    undefined.

%% MinMappers..MaxMappers , MinReducers..MaxReducers

%% also need to support Hadoop's Streaming API

%% [ input reader -> map -> sort-and-shuffle -> combine ] ==>  [ reduce -> output writer ]

-spec split(term()) -> [{k1(),v1()}].
% send {k1(),v1() or [{k1(),v1()}] to mapper (or compbiner): Pid ! {map_result, [{k1(),v1()}]).
-spec split(term(),pid()) -> ok. 
-spec output(term()) -> ok. 

-spec map_before() -> ok.
-spec map(k1(),v1()) -> [{k2(),v2()}]. 
-spec map(k1(),v1(),pid()) -> ok. 
-spec map_after() -> ok.

-spec combine_before() -> ok.
-spec combine([{k2(),v2()}]) -> [{k2(),[v2()]}]. 
-spec combine([{k2(),v2()}],pid()) -> ok. 
-spec combine_after() -> ok.

-spec reduce_before() -> ok.
-spec reduce(k2(),[v2()]) -> [v3()].
-spec reduce(k2(),[v2()],pid()) -> ok.
-spec reduce_after() -> ok.

-spec compare(k2(), k2()) -> -1|0|1.
-spec partition(k2(),v2(),NumReduceTasks::pos_integer()) -> non_neg_integer().

