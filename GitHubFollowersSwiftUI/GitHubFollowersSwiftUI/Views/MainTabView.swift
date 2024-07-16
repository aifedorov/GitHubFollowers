import SwiftUI

struct MainTabView: View {
    enum Tab {
        case search
        case favorites
    }

    @ObservedObject var model: GithubFollowersModel
    @State private var selection: Tab = .search
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                SearchView(model: model)
            }
            .tabItem {
                Label {
                    Text("Followers")
                } icon: {
                    Image(systemName: "person.3")
                }
            }
            .tag(Tab.search)
            
            NavigationStack {
                Text("Favorites Screen")
            }
            .tabItem {
                Label {
                    Text("Favorites")
                } icon: {
                    Image(systemName: "star")
                }
            }
            .tag(Tab.search)
        }
    }
}

#Preview {
    MainTabView(model: .mock)
}
