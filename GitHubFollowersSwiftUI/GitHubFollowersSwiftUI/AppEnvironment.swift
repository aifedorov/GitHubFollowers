import Combine
import GFNetwork

struct AppEnvironment {
    
    let userNetworkService: UserNetworkServiceProtocol
    
    init(userNetworkService: UserNetworkServiceProtocol) {
        self.userNetworkService = userNetworkService
    }
}

extension AppEnvironment {
    
    static let production = AppEnvironment(
        userNetworkService: UserNetworkService(ImageLoader())
    )
}

#if DEBUG
extension AppEnvironment {
    
    static let mock = AppEnvironment(
        userNetworkService: FakeUserNetworkService(FakeImageLoader())
    )
}
#endif
