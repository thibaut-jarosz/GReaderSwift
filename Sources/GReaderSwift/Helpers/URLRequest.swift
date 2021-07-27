import Foundation

extension URLRequest {
    init(url: URL, credentials: Credentials) {
        self.init(url: url)
        setValue("GoogleLogin auth=\(credentials.authKey)", forHTTPHeaderField: "Authorization")
    }
}
