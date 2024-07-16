import SwiftUI

struct SearchResultView: View {
    
    @ObservedObject var model: GithubFollowersModel
    @State private var searchText = ""
    
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
                ForEach(model.followers) { follower in
                    FollowerGridItemView(follower: follower)
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
    }
}

#Preview {
    NavigationStack {
        SearchResultView(model: .mock)
    }
}
