import SwiftUI

struct SearchResultView: View {
    
    @ObservedObject var model: GithubFollowersModel
    @State private var searchText = ""
    @State private var selectedFollower: Follower?
    
    private var filteredFollowers: [Follower] {
        model.followers.filter { $0.matches(searchText: searchText) }
    }
    
    private var gridItems: [GridItem] {
        [
            GridItem(.fixed(96), spacing: 16),
            GridItem(.fixed(96), spacing: 16),
            GridItem(.fixed(96), spacing: 16)
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach(filteredFollowers) { follower in
                    FollowerGridItemView(follower: follower)
                        .onTapGesture {
                            selectedFollower = follower
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding([.top, .bottom], 16)
        }
        .searchable(text: $searchText, prompt: "username")
        .navigationTitle(model.username)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            try? await model.fetchFollowers()
        }
        .sheet(item: $selectedFollower) { follower in
            NavigationStack {
                ProfileView(
                    model: model,
                    username: follower.login
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchResultView(model: .mock)
    }
}
