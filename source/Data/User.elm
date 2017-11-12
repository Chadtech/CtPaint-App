module Data.User exposing (User)


type alias User =
    { email : String
    , name : String
    , profile : String
    , optionsIsOpen : Bool
    }
