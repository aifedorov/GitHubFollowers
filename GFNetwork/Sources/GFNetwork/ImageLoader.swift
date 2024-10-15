import Foundation

public protocol ImageLoaderProtocol: AnyObject, Sendable {
    func downloadImage(from urlString: String) async throws -> Data
}

public final actor ImageLoader: ImageLoaderProtocol {
        
    private let session: URLSession
    private let imageDataCache = NSCache<NSString, NSData>()
    
    public init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidateURL(urlString)
        }
        
        let key = urlString as NSString
        if let data = imageDataCache.object(forKey: key) {
            return data as Data
        }

        let (data, response) = try await session.data(from: url)
        
        guard
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode) else {
            throw NetworkError.wrongResponse
        }
        
        let value = data as NSData
        imageDataCache.setObject(value, forKey: key)
        
        return data
    }
}
