module Code.ProjectDependency exposing
    ( DependencyName(..)
    , ProjectDependency
    , equals
    , fromString
    , same
    , toString
    , toTag
    , viewLibraryBadge
    , viewLibraryBadge_
    )

import Code.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Code.Version as Version exposing (Version)
import Html exposing (Html)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Maybe.Extra as MaybeE
import UI.ContextualTag as ContextualTag
import UI.Icon as Icon
import UI.Tag as Tag exposing (Tag)


type DependencyName
    = UserProject UserHandle ProjectSlug
    | UnqualifiedDependency String


type alias ProjectDependency =
    { name : DependencyName, version : Maybe Version }


fromString : String -> ProjectDependency
fromString raw =
    let
        parts =
            String.split "_" raw

        ( name, version ) =
            case parts of
                [ user, project, major, minor, patch ] ->
                    case ( UserHandle.fromUnprefixedString user, ProjectSlug.fromString project ) of
                        ( Just user_, Just project_ ) ->
                            ( UserProject user_ project_
                            , Version.fromString (String.join "." [ major, minor, patch ])
                            )

                        _ ->
                            ( UnqualifiedDependency ("@" ++ user ++ "/" ++ project)
                            , Version.fromString (String.join "." [ major, minor, patch ])
                            )

                [ n, major, minor, patch ] ->
                    let
                        version_ =
                            Version.fromString (String.join "." [ major, minor, patch ])
                    in
                    case version_ of
                        Just v ->
                            ( UnqualifiedDependency n, Just v )

                        -- It wasn't a version after all, so we give up trying to parse it
                        Nothing ->
                            ( UnqualifiedDependency raw, Nothing )

                [ user, project ] ->
                    case ( UserHandle.fromUnprefixedString user, ProjectSlug.fromString project ) of
                        ( Just user_, Just project_ ) ->
                            ( UserProject user_ project_
                            , Nothing
                            )

                        _ ->
                            ( UnqualifiedDependency ("@" ++ user ++ "/" ++ project)
                            , Nothing
                            )

                [ n ] ->
                    ( UnqualifiedDependency n, Nothing )

                _ ->
                    case List.reverse parts of
                        patch :: minor :: major :: n ->
                            let
                                version_ =
                                    Version.fromString (String.join "." [ major, minor, patch ])
                            in
                            case version_ of
                                Just v ->
                                    ( UnqualifiedDependency (String.join "_" (List.reverse n)), Just v )

                                -- It wasn't a version after all, so we give up trying to parse it
                                Nothing ->
                                    ( UnqualifiedDependency raw, Nothing )

                        _ ->
                            ( UnqualifiedDependency raw, Nothing )
    in
    ProjectDependency name version


equals : ProjectDependency -> ProjectDependency -> Bool
equals a b =
    case ( a.name, b.name ) of
        ( UserProject handleA slugA, UserProject handleB slugB ) ->
            if UserHandle.equals handleA handleB && ProjectSlug.equals slugA slugB then
                case ( a.version, b.version ) of
                    ( Just vA, Just vB ) ->
                        Version.equals vA vB

                    ( Nothing, Nothing ) ->
                        True

                    _ ->
                        False

            else
                False

        ( UnqualifiedDependency nameA, UnqualifiedDependency nameB ) ->
            nameA == nameB

        _ ->
            False


{-| Similar to equals, but less strong. Versions are allowed to be different.
-}
same : ProjectDependency -> ProjectDependency -> Bool
same a b =
    case ( a.name, b.name ) of
        ( UserProject handleA slugA, UserProject handleB slugB ) ->
            UserHandle.equals handleA handleB && ProjectSlug.equals slugA slugB

        ( UnqualifiedDependency nameA, UnqualifiedDependency nameB ) ->
            nameA == nameB

        _ ->
            False


dependencyName : ProjectDependency -> String
dependencyName { name } =
    case name of
        UserProject userHandle projectSlug ->
            UserHandle.toString userHandle ++ "/" ++ ProjectSlug.toString projectSlug

        UnqualifiedDependency n ->
            n


toString : ProjectDependency -> String
toString projectDep =
    let
        name_ =
            dependencyName projectDep
    in
    name_ ++ MaybeE.unwrap "" (\v -> " v" ++ Version.toString v) projectDep.version


toTag : ProjectDependency -> Tag msg
toTag projectDep =
    projectDep
        |> dependencyName
        |> Tag.tag
        |> Tag.large
        |> Tag.withRightText (MaybeE.unwrap "" (\v -> " v" ++ Version.toString v) projectDep.version)


viewLibraryBadge : ProjectDependency -> Html msg
viewLibraryBadge dep =
    viewLibraryBadge_ { withVersion = True } dep


type alias BadgeConfig =
    { withVersion : Bool
    }


viewLibraryBadge_ : BadgeConfig -> ProjectDependency -> Html msg
viewLibraryBadge_ cfg dep =
    let
        label =
            if cfg.withVersion then
                toString dep

            else
                dependencyName dep
    in
    ContextualTag.contextualTag Icon.book label
        |> ContextualTag.decorativePurple
        |> ContextualTag.withTooltipText "Library dependency"
        |> ContextualTag.view
