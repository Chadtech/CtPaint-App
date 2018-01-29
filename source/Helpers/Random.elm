module Helpers.Random
    exposing
        ( finish
        , from
        , value
        )

import Random.Pcg as Random exposing (Generator, Seed)


finish : ( Seed -> a, Seed ) -> a
finish ( ctor, seed ) =
    ctor seed


from : Seed -> a -> ( a, Seed )
from seed a =
    ( a, seed )


value : Generator a -> ( a -> b, Seed ) -> ( b, Seed )
value generator ( ctor, seed ) =
    Random.step generator seed
        |> Tuple.mapFirst ctor
