import Foundation

extension String {
    /// Extract `URLQueryItem` from the string formatted as URL query
    var urlQueryItems: [URLQueryItem] {
        var components = URLComponents()
        components.query = self
        return components.queryItems ?? []
    }
}
