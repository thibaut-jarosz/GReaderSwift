import Foundation

extension URL {
    
    /// Returns a URL constructed by appending the given path and query items to self.
    /// - Returns: A new URL with appended path and query items.
    /// - Parameters:
    ///   - path: The path to append.
    ///   - queryItems: The query items to append.
    func appending(path: URLPath? = nil, queryItems: [URLQueryItem]? = nil) -> URL {
        var url = self
        
        if let aPath = path {
            url.appendPathComponent(aPath.rawValue)
        }
        
        if let items = queryItems, items.count > 0 {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
            var originalItems = components.queryItems ?? []
            originalItems.append(contentsOf: items)
            components.queryItems = originalItems
            if let componentsURL = components.url {
                url = componentsURL
            }
        }
        
        return url
    }
    
}
