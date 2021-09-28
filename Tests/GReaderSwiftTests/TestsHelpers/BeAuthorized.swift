import Foundation
import Nimble

/// A Nimble matcher that succeeds when the URLRequest contains
/// an `Authorization` HTTP header field that looks like `GoogleLogin auth=<authKey>`
/// - Parameter authKey: the auth key that should be found inside the `Authorization` HTTP header field
/// - Returns: An `URLRequest` predicate
public func beAuthorized(withAuthKey authKey: String) -> Predicate<URLRequest> {
    return have(httpHeaderField: "Authorization", at: "GoogleLogin auth=\(authKey)")
}
