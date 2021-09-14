import Foundation

extension URLQueryItem {
    static var jsonOutput: URLQueryItem {
        .init(name: "output", value: "json")
    }
}
