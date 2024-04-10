import SwiftUI

struct MainTabView: View {
    enum Tab {
        case search
        case favorites
    }

    @State private var selection: Tab = .search
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Text("Search Screen")
            }
            .tabItem {
                Label {
                    Text("Followers")
                } icon: {
                    Image(systemName: "person.3")
                }
            }
            .tag(Tab.search)
            
            NavigationView {
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
}
