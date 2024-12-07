import EnumCompatibleTo

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

let a = TopScreen.Tab.myPage.topScreenLogLocation
print(a.rawValue)
