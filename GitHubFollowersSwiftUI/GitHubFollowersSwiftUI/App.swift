import SwiftUI

@main
struct GitHubFollowersSwiftUIApp: App {
    @ObservedObject private var environment = AppEnvironment.production
    @State private var userStore = UserStore(environment: .production)
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .environment(userStore)
        .environmentObject(environment)
    }
}
