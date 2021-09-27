import Foundation
import Nimble

/// A Nimble matcher that succeeds when the URLRequest contains a  HTTP header field with a specific value
/// - Parameters:
///   - httpHeaderField: The name of the HTTP header field
///   - expectedValue: The expected value associated to the HTTP header field
/// - Returns: An `URLRequest` predicate
public func have(httpHeaderField: String, at expectedValue: String) -> Predicate<URLRequest> {
    return Predicate { actualExpression in
        // Always fail if request is nil
        guard let request = try actualExpression.evaluate() else {
            return PredicateResult(
                status: .fail,
                message: .fail("expected to have request, got <nil>").appendedBeNilHint()
            )
        }
        
        // Does not match if there is no matching HTTP header
        guard let currentValue = request.allHTTPHeaderFields?[httpHeaderField] else {
            let actual = "<[\(request.allHTTPHeaderFields?.keys.sorted().joined(separator: ", ") ?? "")]>"
            return PredicateResult(
                status: .doesNotMatch,
                message: .expectedCustomValueTo("have <\(httpHeaderField)> HTTP header", actual: actual)
            )
        }
        
        // Test value of HTTP header
        return PredicateResult(
            bool: currentValue == expectedValue,
            message: .expectedCustomValueTo("have <\(httpHeaderField)> HTTP header value equal to <\(expectedValue)>", actual: "<\(currentValue)>")
        )
    }
}
