import Foundation

/// Represents a single RSS feed.
public struct Subscription: Codable, Equatable {
    public struct ID: StringRepresentable {
        public var rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }
    
    public var id: ID
    public var title: String
    public var categories: [Category]
    public var url: URL?
    public var htmlURL: URL?
    public var iconURL: URL?
    
    public struct Category: Codable, Equatable {
        public var id: Tag.ID
        public var label: String
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case categories
        case url
        case htmlURL = "htmlUrl"
        case iconURL = "iconUrl"
    }
}
