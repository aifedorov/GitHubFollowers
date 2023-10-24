//
//  ErrorDescription.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 20.10.23.
//

import Foundation

enum AlertContent {
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
