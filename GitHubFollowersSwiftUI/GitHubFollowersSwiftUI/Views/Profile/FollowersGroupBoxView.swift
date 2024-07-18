import SwiftUI

struct FollowersGroupBoxView: View {
    
    let user: User
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                HStack {
                    Label("\(user.followers) followers", systemImage: "person.3.fill")
                    Label("\(user.following) following ", systemImage: "person.3.fill")
                }
                .bold()
                
                Button("Show followers") {}
                    .buttonStyle(PrimaryButtonStyle(.medium))
                    .frame(height: 44)
            }
            .padding()
        }
    }
}

#Preview {
    FollowersGroupBoxView(user: .mock)
}
