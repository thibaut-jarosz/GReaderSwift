import Foundation

extension URLRequest {
    /// Creates and authenticate a URL request with the given URL and credentials.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - credentials: The credentials for the request.
    init(url: URL, credentials: Credentials) {
        self.init(url: url)
        setValue("GoogleLogin auth=\(credentials.authKey)", forHTTPHeaderField: "Authorization")
    }
}
