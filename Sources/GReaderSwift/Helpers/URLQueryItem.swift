import Foundation

extension URLQueryItem {
    /// Create a URLQueryItem used to ask for a JSON output
    static var jsonOutput: URLQueryItem {
        .init(name: "output", value: "json")
    }
    
    /// Create a URLQueryItem used to pass credentials' token into a request.
    /// - Parameter credentials: Credentials used to retrieve the token
    /// - Returns: A URLQueryItem
    ///
    ///  This function can perform a request if the token is not cached yet.
    static func token(from credentials: Credentials) async throws -> URLQueryItem {
        await .init(name: "T", value: try credentials.token())
    }
}
