import Foundation

public extension Tag {
    /// Rename a Tag or throws if it cannot be renamed
    /// - Parameters:
    ///   - newName: New name of the tag
    ///   - credentials: Credentials used to connect to the server
    /// - Returns: New tag ID
    @discardableResult func rename(to newName: String, using credentials: Credentials) async throws -> Tag.ID {
        guard let newID = id.renamed(newName) else {
            throw GReaderError.cannotRenameTag
        }
        
        // Create request
        var request = URLRequest(credentials: credentials, path: .tagRename)
        await request.setURLEncodedPostForm([
            .jsonOutput,
            try .token(from: credentials),
            .init(name: "s", value: self.id.rawValue),
            .init(name: "dest", value: newID.rawValue)
        ])
        
        // Send request
        try await request.send()
        
        // Return new Tag ID
        return newID
    }
}
