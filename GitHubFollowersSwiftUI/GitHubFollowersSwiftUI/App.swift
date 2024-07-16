import SwiftUI

@main
struct GitHubFollowersSwiftUIApp: App {
    
    @StateObject private var model = GithubFollowersModel(environment: .production)
    
    var body: some Scene {
        WindowGroup {
            MainTabView(model: model)
        }
    }
}
