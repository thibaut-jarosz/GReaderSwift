import Foundation

public struct Tag: Codable, Equatable {
    public let id: String
    public let type: String?
}

public extension Tag {
    /// Name of the tag if it is a folder inside a `label` subfolder
    public var name: String? {
        guard
            type == "folder",
            let range = id.range(of: "/label/")
        else {
            return nil
        }
        return String(id.suffix(from: range.upperBound))
    }
}
