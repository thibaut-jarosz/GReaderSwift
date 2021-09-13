import Foundation

extension URL {
    
    /// Returns a URL constructed by appending the given path and query items to self.
    /// - Returns: A new URL with appended path and query items.
    /// - Parameters:
    ///   - path: The path to append.
    ///   - queryItems: The query items to append.
    func appending(path: String? = nil, queryItems: [URLQueryItem]? = nil) -> URL {
        var url = self
        
        if let path = path {
            url.appendPathComponent(path)
        }
        
        if let queryItems = queryItems, queryItems.count > 0 {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
            var items = components.queryItems ?? []
            items.append(contentsOf: queryItems)
            components.queryItems = items
            if let componentsURL = components.url {
                url = componentsURL
            }
        }
        
        return url
    }
    
}
