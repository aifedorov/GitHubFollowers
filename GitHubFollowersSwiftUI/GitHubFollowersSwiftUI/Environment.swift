import Combine
import GFNetwork

struct Environment {
    
    let userNetworkService: UserNetworkServiceProtocol
    
    init(userNetworkService: UserNetworkServiceProtocol) {
        self.userNetworkService = userNetworkService
    }
}

extension Environment {
    
    static let production = Environment(
        userNetworkService: UserNetworkService(ImageLoader())
    )
}

#if DEBUG
extension Environment {
    
    static let mock = Environment(
        userNetworkService: FakeUserNetworkService(FakeImageLoader())
    )
}
#endif
