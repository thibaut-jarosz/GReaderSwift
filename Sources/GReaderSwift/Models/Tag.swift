import Foundation

public struct Tag: Codable, Equatable {
    public struct ID: StringRepresentable {
        public var rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }
    
    public var id: ID
    public var type: String?
    public var name: String? { id.name }
}

internal extension Tag.ID {
    /// Name of the tag if it contains a `label` subpath
    var name: String? {
        guard let index = nameStartIndex else {
            return nil
        }
        return String(rawValue.suffix(from: index))
    }
    
    /// Replace the name part of the ID and return the result.
    /// - Parameter newName: The new name
    /// - Returns: The renamed ID or `nil` if there is no name part in the ID
    func renamed(_ newName: String) -> Self?  {
        guard let index = nameStartIndex else {
            return nil
        }
        let newID = rawValue
            .prefix(upTo: index)
            .appending(newName)
        return Self.init(newID)
    }
    
    /// Starting index of the name
    private var nameStartIndex: String.Index? {
        guard let range = rawValue.range(of: "/label/") else {
            return nil
        }
        return range.upperBound
    }
    
}
