@attached(member, names: arbitrary)
public macro EnumCompatibleTo<T>(_ type: T.Type) = #externalMacro(module: "EnumCompatibleToMacros", type: "EnumCompatibleTo")
