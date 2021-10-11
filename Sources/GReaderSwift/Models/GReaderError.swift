import Foundation

/// GReader errors.
public enum GReaderError: Error, Equatable {
    /// Server responded with an http status code >= 300
    case serverResponseError(_ statusCode: Int)
    
    /// Server responded with invalid data
    case invalidDataResponse(_ data: Data?)
    
    /// Tag cannot be renamed because it does not contain `label` subpath
    case cannotRenameTag
}
