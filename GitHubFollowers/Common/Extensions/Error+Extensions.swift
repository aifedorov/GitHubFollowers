import Foundation

enum ErrorContent {
    case userHaveNoFollowers
    case userNotFound
    case networkError
    
    var title: String {
        switch self {
        case .userHaveNoFollowers:
            return "No followers"
        case .userNotFound:
            return "User not found"
        case .networkError:
            return "Network error"
        }
    }
    
    var message: String {
        switch self {
        case .networkError:
            return "Please check the internet connection and try again."
        case .userHaveNoFollowers:
            return "This user doesn't have any followers."
        case .userNotFound:
            return "Sorry, the user not found."
        }
    }
}
