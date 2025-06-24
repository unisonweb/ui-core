module Code.ProjectDependency exposing (DependencyName(..), ProjectDependency, fromString, toString, toTag)

import Code.ProjectSlug as ProjectSlug exposing (ProjectSlug)
import Code.Version as Version exposing (Version)
import Lib.UserHandle as UserHandle exposing (UserHandle)
import Maybe.Extra as MaybeE
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
                    case ( UserHandle.fromString user, ProjectSlug.fromString project ) of
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
                    case ( UserHandle.fromString user, ProjectSlug.fromString project ) of
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
