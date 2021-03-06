import Foundation


/// Protocol used to remove deprecated warning from using `Credentials.cachedToken`
fileprivate protocol CredentialsCachedToken: AnyObject {
    var cachedToken: String? { get set }
}
extension Credentials: CredentialsCachedToken {}


internal extension Credentials {
    /// Retrieve the token, used for advanced requests, from cache or by performing a request on server
    /// - Returns: The token
    func token() async throws -> String {
        // Return token if already retrieved
        if let token = (self as CredentialsCachedToken).cachedToken {
            return token
        }
        
        // Create request
        let request = URLRequest(credentials: self, path: .token)
        
        // Send request
        let data = try await request.send()
        
        // Parse response by getting first non-empty line
        let token = String(data: data, encoding: .utf8)?
            .components(separatedBy: .newlines)
            .first { !$0.isEmpty }
        guard let result = token, !result.isEmpty else {
            throw GReaderError.invalidDataResponse(data)
        }
        
        // Store and return token
        (self as CredentialsCachedToken).cachedToken = result
        return result
    }
}
