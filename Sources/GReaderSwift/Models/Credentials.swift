import Foundation

/// Contains all that is necessary to connect to GReader server.
public final class Credentials {
    
    // MARK: Public vars
    
    /// Base URL of the server.
    public let baseURL: URL
    /// Username (or email) of the user.
    public let username: String
    /// Authorization key associated to the username on the server.
    public let authKey: String
    
    // MARK: Private vars
    
    @available(*, deprecated, message: "Do not use directly, use `token(from:)` instead.")
    internal var cachedToken: String?
    
    // MARK: - Initializer
    
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

// MARK: - Codable
extension Credentials: Codable {
    enum CodingKeys: String, CodingKey {
        case baseURL
        case username
        case authKey
    }
}
