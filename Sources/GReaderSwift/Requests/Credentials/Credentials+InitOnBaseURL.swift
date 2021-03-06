import Foundation

public extension Credentials {
    /// Create credentials after retrieving the authorization key using given base URL, username and password.
    /// - Parameters:
    ///   - baseURL: The base URL of the server.
    ///   - username: The username (or email) used to authenticate on the server.
    ///   - password: The password (or API password) of the username.
    convenience init(on baseURL: URL, username: String, password: String) async throws {
        // Create request
        var request = URLRequest(url: baseURL.appending(path: .clientLogin))
        request.setURLEncodedPostForm([
            .init(name: "Email", value: username),
            .init(name: "Passwd", value: password),
        ])
        
        // Send request
        let data = try await request.send()
        
        // Parse response: auth key is stored in the line that starts with "Auth="
        let auth = String(data: data, encoding: .utf8)?.parsedLoginResponse["Auth"] ?? ""
        if auth.isEmpty {
            throw GReaderError.invalidDataResponse(data)
        }
        self.init(
            baseURL: baseURL,
            username: username,
            authKey: auth
        )
    }
}

fileprivate extension String {
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
