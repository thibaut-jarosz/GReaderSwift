import Foundation

internal extension Credentials {
    /// Retrieve the token, used for advanced requests, from cache or by performing a request on server
    /// - Returns: The token
    func token() async throws -> String {
        // Return token is already retrieved
        if let token = privateToken {
            return token
        }
        
        // Create request
        let request = URLRequest(credentials: self, path: .token)
        
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
        
        // Store and return token
        self.privateToken = token
        return token
    }
}