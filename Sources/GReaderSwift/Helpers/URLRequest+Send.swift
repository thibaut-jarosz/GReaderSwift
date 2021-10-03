import Foundation

extension URLRequest {
    /// Send the request
    /// - Returns: Data returned by the server
    @discardableResult func send() async throws -> Data {
        // Send request
        let (data, response) = try await URLSession.shared.data(for: self)
        
        // Check response status code
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            throw GReaderError.serverResponseError(statusCode)
        }
        
        return data
    }
    
    /// Send the request and decode JSON data
    /// - Parameter responseType: The type of data contained inside the response. Must be in JSON format.
    /// - Returns: Decoded JSON data
    func send<T>(withJSONResponse responseType: T.Type) async throws -> T where T:Decodable {
        // Send request
        let data = try await send()
        
        // Parse response
        do {
            return try JSONDecoder().decode(responseType, from: data)
        }
        catch {
            // Throw invalidDataResponse if JSON cannot be decoded
            throw GReaderError.invalidDataResponse(data)
        }
    }
}
