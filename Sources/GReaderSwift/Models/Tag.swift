import Foundation

public struct Tag: Codable, Equatable {
    let id: String
    let type: String?
}

extension Tag {
    /// Name of the tag if it is a folder inside a `label` subfolder
    var name: String? {
        guard
            type == "folder",
            let range = id.range(of: "/label/")
        else {
            return nil
        }
        return String(id.suffix(from: range.upperBound))
    }
}
