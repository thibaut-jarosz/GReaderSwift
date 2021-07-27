import Foundation

public struct Credentials: Codable, Equatable {
    public var baseURL: URL
    public var username: String
    public var authKey: String
}

extension Credentials {
    public init(on baseURL: URL, username: String, password: String) async throws {
        // Prepare form-urlencoded POST data
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            .init(name: "Email", value: username),
            .init(name: "Passwd", value: password),
        ]
        
        // Create request
        var request = URLRequest(url: baseURL.appendingPathComponent("accounts/ClientLogin"))
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        // Send request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status code
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 300 {
            throw GReaderError.serverResponseError(statusCode)
        }
        
        // Parse response: auth key is stored in the line that starts with "Auth="
        let auth = String(data: data, encoding: .utf8)?.parsedLoginResponse["Auth"] ?? ""
        if auth.isEmpty {
            throw GReaderError.invalidDataResponse
        }
        self.init(
            baseURL: baseURL,
            username: username,
            authKey: auth
        )
    }
}

private extension String {
    /// Transform a string of "key=value" lines into dict
    var parsedLoginResponse: [String:String] {
        // Get lines
        components(separatedBy: .newlines)
            .map { line in
                // Get array of key and value (max 2 items per array)
                line.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
                    .map(String.init)
            }
            .reduce([String:String]()) { dict, array in
                // store result in dict if there is both a key and a value
                var dict = dict
                if array.count == 2 {
                    dict[array[0]] = array[1]
                }
                return dict
            }
    }
}
