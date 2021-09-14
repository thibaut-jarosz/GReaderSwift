import Foundation

/// Token used to perform actions that change data (create, update, delete…).
public struct AccessToken: RawRepresentable {
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AccessToken {
    /// Create an access token after retrieving its value using given credentials.
    /// - Parameter credentials: Credentials used to retrieve the value of the access token.
    public init(credentials: Credentials) async throws {
        // Create request
        let request = URLRequest(
            credentials: credentials,
            path: "reader/api/0/token"
        )
        
        // Send request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            throw GReaderError.serverResponseError(statusCode)
        }
        
        // Parse response by getting first non-empty line
        let token = String(data: data, encoding: .utf8)?
            .components(separatedBy: .newlines)
            .first { !$0.isEmpty }
        guard let token = token, !token.isEmpty else {
            throw GReaderError.invalidDataResponse(data)
        }
        self.rawValue = token
    }
}
