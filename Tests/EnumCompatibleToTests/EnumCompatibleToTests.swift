import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(EnumCompatibleToMacros)
import EnumCompatibleToMacros

let testMacros: [String: Macro.Type] = [
    "EnumCompatibleTo": EnumCompatibleTo.self,
]
#endif

final class EnumCompatibleToTests: XCTestCase {
    func testMacro() throws {
        #if canImport(EnumCompatibleToMacros)
        assertMacroExpansion(
            """
            @EnumCompatibleTo(Fuga.self)
            enum Hoge {
                case a
                case b
            }
            """,
            expandedSource: """
            enum Hoge {
                case a
                case b

                var fuga: Fuga {
                    switch self {
                    case .a:
                        .a
                    case .b:
                        .b
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
