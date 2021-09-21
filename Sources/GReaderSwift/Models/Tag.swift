import Foundation

public struct Tag: Codable, Equatable {
    public let id: String
    public let type: String?
}

public extension Tag {
    /// Name of the tag if it is a folder inside a `label` subfolder
    public var name: String? {
        guard
            type == "folder",
            let range = id.range(of: "/label/")
        else {
            return nil
        }
        return String(id.suffix(from: range.upperBound))
    }
}

public extension Tag {
    private struct TagContainer: Codable {
        let tags: [Tag]
    }
    
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
