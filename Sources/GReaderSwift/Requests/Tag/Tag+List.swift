import Foundation

public extension Tag {
    private struct TagContainer: Codable {
        let tags: [Tag]
    }
    
    /// Retrieve a list of all Tags on the server described in given credentials
    /// - Parameter credentials: Credentials used to connect to the server
    /// - Returns: A list of all Tags.
    static func list(using credentials: Credentials) async throws -> [Tag] {
        // Create request
        let request = URLRequest(
            credentials: credentials,
            path: .tagList,
            queryItems: [.jsonOutput]
        )
        
        // Send request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            throw GReaderError.serverResponseError(statusCode)
        }
        
        // Parse response by getting first non-empty line
        do {
            return try JSONDecoder().decode(TagContainer.self, from: data).tags
        }
        catch {
            // Throw invalidDataResponse if JSON cannot be decoded
            throw GReaderError.invalidDataResponse(data)
        }
    }
}
