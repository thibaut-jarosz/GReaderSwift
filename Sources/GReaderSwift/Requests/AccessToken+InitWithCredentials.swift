import Foundation

public extension AccessToken {
    /// Create an access token after retrieving its value using given credentials.
    /// - Parameter credentials: Credentials used to retrieve the value of the access token.
    init(credentials: Credentials) async throws {
        // Create request
        let request = URLRequest(credentials: credentials, path: .token)
        
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