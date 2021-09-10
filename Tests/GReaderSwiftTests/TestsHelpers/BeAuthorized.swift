import Foundation
import Nimble

/// A Nimble matcher that succeeds when the URLRequest contains
/// an `Authorization` HTTP header field that looks like `GoogleLogin auth=<authKey>`
/// - Parameter authKey: the auth key that should be found inside the `Authorization` HTTP header field
/// - Returns: An `URLRequest` predicate
public func beAuthorized(withAuthKey authKey: String) -> Predicate<URLRequest> {
    return Predicate { actualExpression in
        // Always fail if request is nil
        guard let request = try actualExpression.evaluate() else {
            return PredicateResult(
                status: .fail,
                message: .fail("expected to have request, got <nil>").appendedBeNilHint()
            )
        }
        
        // Does not match if the is no `Authorization` HTTP header
        guard let authorization = request.allHTTPHeaderFields?["Authorization"] else {
            let actual: String
            if let keys = request.allHTTPHeaderFields?.keys {
                actual = "<[\(keys.sorted().joined(separator: ", "))]>"
            }
            else {
                actual = "<nil>"
            }
            return PredicateResult(
                status: .doesNotMatch,
                message: .expectedCustomValueTo("have <Authorization> HTTP header field", actual: actual)
            )
        }
        
        // Test value of `Authorization` HTTP header
        let expectedValue = "GoogleLogin auth=\(authKey)"
        return PredicateResult(
            bool: authorization == expectedValue,
            message: .expectedCustomValueTo("equal <\(expectedValue)>", actual: "<\(authorization)>")
        )
    }
}
