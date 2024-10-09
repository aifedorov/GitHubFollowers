import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var environment: AppEnvironment
    @Environment(\.dismiss) var dismiss
    @State private var user: User?
    
    let username: String
    
    var body: some View {
        NavigationStack {
            if let user {
                VStack(spacing: 30) {
                    
                    ProfileHeaderView(user: user)
                    
                    VStack(spacing: 16) {
                        FollowersGroupBoxView(user: user)
                        ReposGroupBoxView(user: user)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("On Github from \(user.createdAtFormatted)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "star")
                }
            }
        }
        .task {
            do {
                user = try await environment.userNetworkService.fetchUserInfo(for: username)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(username: "testuser")
    }
}
