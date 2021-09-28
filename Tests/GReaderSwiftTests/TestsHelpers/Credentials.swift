@testable import GReaderSwift

/// Protocol used to remove deprecated warning from using `Credentials.cachedToken`
fileprivate protocol CredentialsCachedToken: AnyObject {
    var cachedToken: String? { get set }
}
extension Credentials: CredentialsCachedToken {}

extension Credentials {
    /// Wrapper around `cachedToken` to prevent warnings when using it
    var cachedTokenTestAccess: String? {
        get { (self as CredentialsCachedToken).cachedToken }
        set { (self as CredentialsCachedToken).cachedToken = newValue }
    }
}
