module Test.Generated.Main exposing (main)

import Code.CodebaseTree.NamespaceListingTests
import Code.Definition.DocTests
import Code.Finder.SearchOptionsTests
import Code.FullyQualifiedNameTests
import Code.HashQualifiedTests
import Code.HashTests
import Code.ProjectTests
import Code.Workspace.WorkspaceItemsTests
import Lib.SearchResultsTests
import Lib.TreePathTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport UseColor
        , seed = 66268589582276
        , processes = 16
        , globs =
            []
        , paths =
            [ "/Users/hojberg/code/unison/ui-core/tests/Code/CodebaseTree/NamespaceListingTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/Definition/DocTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/Finder/SearchOptionsTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/FullyQualifiedNameTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/HashQualifiedTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/HashTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/ProjectTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Code/Workspace/WorkspaceItemsTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Lib/SearchResultsTests.elm"
            , "/Users/hojberg/code/unison/ui-core/tests/Lib/TreePathTests.elm"
            ]
        }
        [ ( "Code.CodebaseTree.NamespaceListingTests"
          , [ Test.Runner.Node.check Code.CodebaseTree.NamespaceListingTests.map
            ]
          )
        , ( "Code.Definition.DocTests"
          , [ Test.Runner.Node.check Code.Definition.DocTests.mergeWords
            , Test.Runner.Node.check Code.Definition.DocTests.isDocFoldToggled
            , Test.Runner.Node.check Code.Definition.DocTests.toString
            , Test.Runner.Node.check Code.Definition.DocTests.toggleFold
            , Test.Runner.Node.check Code.Definition.DocTests.id
            ]
          )
        , ( "Code.Finder.SearchOptionsTests"
          , [ Test.Runner.Node.check Code.Finder.SearchOptionsTests.init
            , Test.Runner.Node.check Code.Finder.SearchOptionsTests.removeWithin
            , Test.Runner.Node.check Code.Finder.SearchOptionsTests.namespaceFqn
            , Test.Runner.Node.check Code.Finder.SearchOptionsTests.perspectiveFqn
            , Test.Runner.Node.check Code.Finder.SearchOptionsTests.namespacePerspective
            , Test.Runner.Node.check Code.Finder.SearchOptionsTests.codebasePerspective
            ]
          )
        , ( "Code.FullyQualifiedNameTests"
          , [ Test.Runner.Node.check Code.FullyQualifiedNameTests.cons
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.snoc
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.append
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.fromString
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.fromUrlString
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.toString
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.toUrlString
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.fromParent
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.unqualifiedName
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.isSuffixOf
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.namespaceOf
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.namespace
            , Test.Runner.Node.check Code.FullyQualifiedNameTests.segments
            ]
          )
        , ( "Code.HashQualifiedTests"
          , [ Test.Runner.Node.check Code.HashQualifiedTests.name
            , Test.Runner.Node.check Code.HashQualifiedTests.hash
            , Test.Runner.Node.check Code.HashQualifiedTests.fromUrlString
            , Test.Runner.Node.check Code.HashQualifiedTests.name_
            , Test.Runner.Node.check Code.HashQualifiedTests.urlName_
            , Test.Runner.Node.check Code.HashQualifiedTests.hash_
            ]
          )
        , ( "Code.HashTests"
          , [ Test.Runner.Node.check Code.HashTests.equals
            , Test.Runner.Node.check Code.HashTests.toShortString
            , Test.Runner.Node.check Code.HashTests.stripHashPrefix
            , Test.Runner.Node.check Code.HashTests.toUrlString
            , Test.Runner.Node.check Code.HashTests.fromString
            , Test.Runner.Node.check Code.HashTests.fromUrlString
            , Test.Runner.Node.check Code.HashTests.isRawHash
            ]
          )
        , ( "Code.ProjectTests"
          , [ Test.Runner.Node.check Code.ProjectTests.slug
            , Test.Runner.Node.check Code.ProjectTests.project
            ]
          )
        , ( "Code.Workspace.WorkspaceItemsTests"
          , [ Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.appendWithFocus
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.prependWithFocus
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.insertWithFocusAfter
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.insertWithFocusBefore
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.replace
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.remove
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.member
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.next
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.prev
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.focusedReference
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.moveUp
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.moveDown
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.map
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.mapToList
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.termRef
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.notFoundRef
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.hashQualified
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.term
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.before
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.focused
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.after
            , Test.Runner.Node.check Code.Workspace.WorkspaceItemsTests.workspaceItems
            ]
          )
        , ( "Lib.SearchResultsTests"
          , [ Test.Runner.Node.check Lib.SearchResultsTests.fromList
            , Test.Runner.Node.check Lib.SearchResultsTests.next
            , Test.Runner.Node.check Lib.SearchResultsTests.prev
            , Test.Runner.Node.check Lib.SearchResultsTests.getAt
            , Test.Runner.Node.check Lib.SearchResultsTests.mapToList
            ]
          )
        , ( "Lib.TreePathTests"
          , [ Test.Runner.Node.check Lib.TreePathTests.toString
            ]
          )
        ]