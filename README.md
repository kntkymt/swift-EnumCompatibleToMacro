# swift-EnumCompatibleToMacro

Swift-EnumCompatibleToMacro is a Swift Compiler Plugin (macro) that provides an automated way to generate a computed property for converting one enum to another when they share the same case names.

# How to use

```swift
struct TopScreen {
    @EnumCompatibleTo(TopScreenLogLocation.self)
    enum Tab {
        case home
        case search
        case myPage
    }
}

enum TopScreenLogLocation: String {
    case home
    case search
    case myPage = "my_page"
    case navigationBar = "navigation_bar"
    case button
}

let myPage = TopScreen.Tab.myPage
print(myPage.topScreenLogLocation.rawValue) // my_page
```
