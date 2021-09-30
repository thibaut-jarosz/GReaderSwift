import Foundation

public extension Tag {
    /// Delete a Tag
    /// - Parameter credentials: Credentials used to connect to the server
    func delete(using credentials: Credentials) async throws {
        // Create request
        var request = URLRequest(credentials: credentials, path: .tagDelete)
        await request.setURLEncodedPostForm([
            .jsonOutput,
            try .token(from: credentials),
            .init(name: "s", value: self.id),
        ])
        
        // Send request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            throw GReaderError.serverResponseError(statusCode)
        }
    }
}
