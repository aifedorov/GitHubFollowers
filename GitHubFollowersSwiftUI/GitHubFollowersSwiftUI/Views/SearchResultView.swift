import SwiftUI

struct SearchResultView: View {
    @Environment(UserStore.self) private var userStore
    @State private var selectedFollower: Follower?
        
    private var gridItems: [GridItem] {
        [
            GridItem(.fixed(96), spacing: 16),
            GridItem(.fixed(96), spacing: 16),
            GridItem(.fixed(96), spacing: 16)
        ]
    }
    
    var body: some View {
        @Bindable var userStoreBindable = userStore
        
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach(userStore.filteredFollowers) { follower in
                    FollowerGridItemView(follower: follower)
                        .onTapGesture {
                            selectedFollower = follower
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding([.top, .bottom], 16)
        }
        .searchable(text: $userStoreBindable.searchText, prompt: "username")
        .navigationTitle(userStore.username)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            try? await userStore.fetchFollowers()
        }
        .sheet(item: $selectedFollower) { follower in
            NavigationStack {
                ProfileView(
                    username: follower.login
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchResultView()
            .environment(UserStore(environment: .mock))
    }
}
