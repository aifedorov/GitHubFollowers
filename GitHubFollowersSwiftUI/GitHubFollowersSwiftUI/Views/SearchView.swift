import SwiftUI
import GFCommon

struct SearchView: View {
    
    @ObservedObject var model: GithubFollowersModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 40) {
                    Image("mainLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 85)

                    TextField("Enter username", text: $model.username)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24))
                        .frame(height: 64)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color("texFieldBackgroundColor"))
                        }
                        .autocapitalization(.none)
                        .padding(.horizontal)
                }
                
                Spacer()
                Spacer()
                Spacer()
                                
                NavigationLink {
                    SearchResultView(model: model)
                } label: {
                    Text("Get followers")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .disabled(!model.username.isValidGitHubUsername)
            }
        }
    }
}

#Preview {
    SearchView(model: .mock)
}
