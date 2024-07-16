import SwiftUI

struct FollowerGridItemView: View {
    let follower: Follower
    
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: follower.avatarUrl) ?? .init(string: "https://example.com/icon.png")
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("avatarPlaceholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(follower.login)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .padding(4)
    }
}

#Preview() {
    FollowerGridItemView(follower: .mock)
        .frame(width: 96, height: 96)
}
