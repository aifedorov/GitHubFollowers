import SwiftUI

struct ReposGroupBoxView: View {
    
    let user: User
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                HStack {
                    Label("\(user.publicRepos) repos", systemImage: "book.pages")
                }
                .bold()
                
                Button("Open Profile") {
                    if let url = URL(string: user.htmlUrl) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(PrimaryButtonStyle(.medium))
                .frame(height: 44)
            }
            .padding()
        }
    }
}
