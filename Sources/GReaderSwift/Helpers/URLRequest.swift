import Foundation

extension URLRequest {
    
    /// Creates and authorize a URL request using the given credentials, path and query items.
    /// - Parameters:
    ///   - credentials: The credentials used to determine the base URL and authorization key.
    ///   - path: The path that will be combined with the base URL to determine the full URL.
    ///   - queryItems: Query items added to the request.
    init(credentials: Credentials, path: URLPath, queryItems: [URLQueryItem]? = nil) {
        let url = credentials.baseURL.appending(path: path, queryItems: queryItems)
        
        self.init(url: url)
        setValue("GoogleLogin auth=\(credentials.authKey)", forHTTPHeaderField: "Authorization")
    }
    
    /// Configure the request for URL encoded POST form, using URLQueryItems as body.
    /// - Parameter items: The URL Query items used to create the body of the request.
    mutating func setURLEncodedPostForm(_ items: [URLQueryItem]) {
        var components = URLComponents()
        components.queryItems = items
        
        self.httpBody = components.query?.data(using: .utf8)
        self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.httpMethod = "POST"
    }
}
