import Foundation
import Nimble

/// A Nimble matcher that succeeds when the URLRequest is an `application/x-www-form-urlencoded`
/// and the content match the given URLQueryItems.
/// - Parameter form: the list of all items that should be found inside the data of the request
/// - Returns: An `URLRequest` predicate
public func haveURLEncodedForm(_ form: [URLQueryItem]) -> Predicate<URLRequest> {
    return Predicate { actualExpression in
        // Check Content-Type header
        let contentTypePredicate = have(httpHeaderField: "Content-Type", at: "application/x-www-form-urlencoded")
        let contentTypeResult = try contentTypePredicate.satisfies(actualExpression)
        if contentTypeResult.status != .matches {
            return contentTypeResult
        }
        
        // Check Data
        return try compareData(in: actualExpression, with: form)
    }
}

fileprivate func compareData(in actualExpression: Expression<URLRequest>, with form: [URLQueryItem]) throws -> PredicateResult {
    // Always fail if request is nil
    guard let request = try actualExpression.evaluate() else {
        return PredicateResult(
            status: .fail,
            message: .fail("expected to have request, got <nil>").appendedBeNilHint()
        )
    }
    
    var components = URLComponents()
    components.queryItems = form
    let expectedValue = components.query ?? ""
    
    // Does not match if body is nil
    guard let bodyString = request.httpBodyString else {
        return PredicateResult(
            status: .doesNotMatch,
            message: .expectedCustomValueTo("have <\(expectedValue)> body", actual: "<nil>")
        )
    }
    
    // Test value of body
    return PredicateResult(
        bool: bodyString == expectedValue,
        message: .expectedCustomValueTo("have <\(expectedValue)> body", actual: "<\(bodyString)>")
    )
}

fileprivate extension URLRequest {
    var httpBodyString: String? {
        if let body = httpBody,
           let result = String(data: body, encoding: .utf8) {
            return result
        }
        return httpBodyStreamString
    }
}
