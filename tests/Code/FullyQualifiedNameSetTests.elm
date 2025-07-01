module Code.FullyQualifiedNameSetTests exposing (..)

import Code.FullyQualifiedName as FQN
import Code.FullyQualifiedNameSet as FQNSet
import Expect
import Test exposing (..)


isPrefixOfAny : Test
isPrefixOfAny =
    describe "FQNSet.isPrefixOfAny"
        [ test "returns true when the given FQN is a prefix of any of the members of the set" <|
            \_ ->
                let
                    prefix =
                        FQN.fromList [ "BlogAuthor" ]

                    set =
                        FQNSet.fromList
                            [ FQN.fromList [ "BlogAuthor", "avatar" ]
                            , FQN.fromList [ "Blog", "view" ]
                            , FQN.fromList [ "Css", "toText" ]
                            ]
                in
                Expect.equal True (FQNSet.isPrefixOfAny set prefix)
        ]
