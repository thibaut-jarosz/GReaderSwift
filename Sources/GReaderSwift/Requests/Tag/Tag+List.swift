import Foundation

public extension Tag {
    private struct TagContainer: Codable {
        let tags: [Tag]
    }
    
    /// Retrieve a list of all Tags on the server described in given credentials
    /// - Parameter credentials: Credentials used to connect to the server
    /// - Returns: A list of all Tags.
    static func list(using credentials: Credentials) async throws -> [Tag] {
        try await URLRequest(
            credentials: credentials,
            path: .tagList,
            queryItems: [.jsonOutput]
        )
        .send(withJSONResponse: TagContainer.self)
        .tags
    }
}
