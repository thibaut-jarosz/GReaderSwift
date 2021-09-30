import Foundation

/// A list of all relavive Paths on a server
enum URLPath: String {
    case clientLogin = "accounts/ClientLogin"
    case tagList = "reader/api/0/tag/list"
    case tagRename = "reader/api/0/rename-tag"
    case tagDelete = "reader/api/0/disable-tag"
    case token = "reader/api/0/token"
}
