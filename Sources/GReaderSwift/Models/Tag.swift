import Foundation

public struct Tag: Codable, Equatable {
    public struct ID: StringRepresentable {
        public var rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }
    
    public var id: ID
    public var type: String?
}

public extension Tag {
    /// Name of the tag if it contains a `label` subpath
    var name: String? {
        guard let index = nameStartIndex else {
            return nil
        }
        return String(id.rawValue.suffix(from: index))
    }
    
    /// Rename the tag if it contains a `label` subpath
    /// - Parameter newName: The new name
    internal mutating func setName(_ newName: String) throws {
        guard let index = nameStartIndex else {
            throw GReaderError.cannotRenameTag
        }
        self.id = .init(id.rawValue.prefix(upTo: index).appending(newName))
    }
    
    /// Starting index of the name
    private var nameStartIndex: String.Index? {
        guard let range = id.rawValue.range(of: "/label/") else {
            return nil
        }
        return range.upperBound
    }
}
