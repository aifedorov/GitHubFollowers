import Foundation

public enum SearchResultErrorContent {
    case userHaveNoFollowers
    case userNotFound
    case networkError
    
    public var title: String {
        switch self {
        case .userHaveNoFollowers:
            return "No followers"
        case .userNotFound:
            return "User not found"
        case .networkError:
            return "Network error"
        }
    }
    
    public var message: String {
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

public enum FavoritesErrorContent {
    case noFavorites
    case unknownError
    
    public var title: String {
        switch self {
        case .noFavorites:
            return "No favorites"
        case .unknownError:
            return "Technical Error"
        }
    }
    
    public var message: String {
        switch self {
        case .noFavorites:
            return "You haven’t added any users yet."
        case .unknownError:
            return "Something is wrong. Please try again later."
        }
    }
}
