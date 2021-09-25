import Foundation

/// Contains all that is necessary to connect to GReader server.
public struct Credentials: Codable, Equatable {
    /// Base URL of the server.
    public var baseURL: URL
    /// Username (or email) of the user.
    public var username: String
    /// Authorization key associated to the username on the server.
    public var authKey: String
}
