import Foundation

/// Contains all that is necessary to connect to GReader server.
public final class Credentials: Codable {
    
    /// Base URL of the server.
    public let baseURL: URL
    /// Username (or email) of the user.
    public let username: String
    /// Authorization key associated to the username on the server.
    public let authKey: String
    
    // MARK: -
    
    /// Create credentials using given base URL, username and authKey,
    /// - Parameters:
    ///   - baseURL: The base URL of the server.
    ///   - username: The username (or email) used to authenticate on the server.
    ///   - authKey: The authorization key used to authorize requests on the server.
    public init(baseURL: URL, username: String, authKey: String) {
        self.baseURL = baseURL
        self.username = username
        self.authKey = authKey
    }
}
