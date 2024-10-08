import SwiftUI

struct MainTabView: View {
    
    enum Tab {
        case search
        case favorites
    }

    @Environment(UserStore.self) private var userStore
    @State private var selection: Tab = .search
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                SearchView()
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
    MainTabView()
        .environment(UserStore(environment: .mock))
}
