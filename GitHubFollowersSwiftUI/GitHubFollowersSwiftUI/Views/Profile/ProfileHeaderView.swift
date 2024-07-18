import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(
                url: URL(string: user.avatarUrl)
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                if let name = user.name {
                    Text(name)
                        .font(.largeTitle)
                }
                
                Text(user.login)
                    .font(.callout)
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    ProfileHeaderView(user: .mock)
}
