//
//  NetworkError.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 20.10.23.
//

import Foundation

enum NetworkError: Error {
    case invalidateURL(String)
    case wrongResponse
    case invalidateJSON(DecodingError)
    case resourceNotFound
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidateJSON(let decodingError):
            return "Invalidate JSON data: \(decodingError.localizedDescription)."
        case .invalidateURL(let urlString):
            return "Invalidate url: \(urlString)."
        case .wrongResponse:
            return "Wrong response from server."
        case .resourceNotFound:
            return "Resource not found. Please, try again."
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
}
