
-module(sc_autosprite).





-export([

    layout/1

]).





layout(Sizes) ->

    MasterLength = length(Sizes),
    CheckLength  = length([ 1 || {_Name,X,Y} <- Sizes, is_integer(X), is_integer(Y), X > 0, Y > 0 ]),

    if MasterLength =/= CheckLength -> throw({ error, "All layout sizes must be {X,Y} positive integer pixel sizes" }); true -> ok end,

    Areas                       = [ X*Y || {_Name,X,Y} <- Sizes ],
    SumArea                     = lists:sum(Areas),
    
    { _Names, Widths, Heights } = lists:unzip3(Sizes),
    { MinWidth, MaxWidth }      = sc:extrema(Widths),
    { MinHeight, MaxHeight }    = sc:extrema(Heights),

    WP = width_pack(MaxWidth, Sizes),

    { WP, Areas, SumArea, MinWidth, MaxWidth, MinHeight, MaxHeight }.





width_pack(MaxWidth, Sizes) ->

    WAreas = lists:reverse(lists:keysort(2, Sizes)),

    [seq_pack(MaxWidth, WAreas), MaxWidth].





seq_pack(Width, Sizes) ->

    seq_pack(Width, Sizes, [], 0).





seq_pack(_Width, [], Layout, _AtHeight) ->

    Layout;





seq_pack(Width, [ThisSize|RemSizes], Layout, AtHeight) ->

    {_Name,_X,Y} = ThisSize,
    seq_pack(Width, RemSizes, [{ThisSize,{0,AtHeight}}]++Layout, AtHeight+Y).
