import SwiftUI
import GFCommon

struct SearchView: View {
    @Environment(UserStore.self) private var userStore
    
    var body: some View {
        @Bindable var userStoreBindable = userStore
        
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 40) {
                    Image("mainLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 85)

                    TextField("Enter username", text: $userStoreBindable.username)
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
                    SearchResultView()
                } label: {
                    Text("Get followers")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .disabled(!userStoreBindable.username.isValidGitHubUsername)
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(UserStore(environment: .mock))
}
