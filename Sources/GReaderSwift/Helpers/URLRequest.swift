import Foundation

extension URLRequest {
    
    /// Creates and authorize a URL request using the given credentials, path and query items.
    /// - Parameters:
    ///   - credentials: The credentials used to determine the base URL and authorization key.
    ///   - path: The path that will be combined with the base URL to determine the full URL.
    ///   - queryItems: Query items added to the request.
    init(credentials: Credentials, path: String, queryItems: [URLQueryItem]? = nil) {
        let url = credentials.baseURL.appending(path: path, queryItems: queryItems)
        
        self.init(url: url)
        setValue("GoogleLogin auth=\(credentials.authKey)", forHTTPHeaderField: "Authorization")
    }
    
}
