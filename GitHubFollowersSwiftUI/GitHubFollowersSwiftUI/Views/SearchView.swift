import SwiftUI
import GFCommon

struct SearchView: View {
    
    @ObservedObject var model: GithubFollowersModel
    
    @State private var isSearchResultPresented = false
    
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
                
                Button {
                    isSearchResultPresented.toggle()
                } label: {
                    Text("Get followers")
                }
                .disabled(!model.username.isValidGitHubUsername)
                .buttonStyle(.primaryButton)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationDestination(isPresented: $isSearchResultPresented) {
                SearchResultView(model: model)
            }
        }
    }
}

#Preview {
    SearchView(model: .mock)
}
