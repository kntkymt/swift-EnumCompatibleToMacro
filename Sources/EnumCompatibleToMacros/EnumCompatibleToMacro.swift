import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EnumCompatibleTo: MemberMacro {
    private enum EnumCompatibleToMacroError: Error {
        case invalidArgument
        case declationIsNotEnum
    }

    public static func getTargetTypeName(of node: AttributeSyntax) throws -> String {
        let labeledExprList = node.arguments?.as(LabeledExprListSyntax.self)
        let memberAccess = labeledExprList?.first?.expression.as(MemberAccessExprSyntax.self)
        guard let targetTypeName = memberAccess?.base?.as(DeclReferenceExprSyntax.self)?.baseName.text else {
            throw EnumCompatibleToMacroError.invalidArgument
        }

        return targetTypeName
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let targetTypeName = try getTargetTypeName(of: node)

        guard let selfEnum = declaration.as(EnumDeclSyntax.self) else {
            throw EnumCompatibleToMacroError.declationIsNotEnum
        }

        let enumCases = selfEnum.memberBlock.members.compactMap({
            EnumCaseDeclSyntax($0.decl)?.elements.first?.name.text
        })

        let propertyName = (targetTypeName.first?.lowercased() ?? "") + String(targetTypeName.dropFirst())

        let switchCase = try SwitchExprSyntax(
            "switch self",
            casesBuilder: {
                for enumCase in enumCases {
                    SwitchCaseSyntax(
                        "case .\(raw: enumCase): .\(raw: enumCase)"
                    )
                }
            }
        )
        return [
            DeclSyntax(stringLiteral: """
var \(propertyName): \(targetTypeName) {
    \(switchCase.formatted())
}
""")
        ]
    }
}

@main
struct EnumCompatibleToPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumCompatibleTo.self,
    ]
}
