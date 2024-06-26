import Foundation

public enum StorageError: Error {
    case savingError
    case encodingError(EncodingError)
    case fileReadNoSuchFile
    case unknown(Error?)
}

extension StorageError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .fileReadNoSuchFile:
            return "File not found."
        case let .unknown(error):
            guard let error else {
                return "Unknown error."
            }
            return "Unexpected error: \(error.localizedDescription)."
        case .encodingError(let error):
            return "Invalidate data: \(error.localizedDescription)."
        case .savingError:
            return "An error occurred while saving the data"
        }
    }
}
