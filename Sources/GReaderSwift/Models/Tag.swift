import Foundation

public struct Tag: Codable, Equatable {
    public var id: String
    public var type: String?
}

public extension Tag {
    /// Name of the tag if it is a folder inside a `label` subfolder
    var name: String? {
        guard let index = nameStartIndex else {
            return nil
        }
        return String(id.suffix(from: index))
    }
    
    /// Rename the tag if it is a folder inside a `label` subfolder
    /// - Parameter newName: The new name
    internal mutating func setName(_ newName: String) throws {
        guard let index = nameStartIndex else {
            throw GReaderError.cannotRenameTag
        }
        self.id = id.prefix(upTo: index).appending(newName)
    }
    
    /// Starting index of the name
    private var nameStartIndex: String.Index? {
        guard
            type == "folder",
            let range = id.range(of: "/label/")
        else {
            return nil
        }
        return range.upperBound
    }
}
