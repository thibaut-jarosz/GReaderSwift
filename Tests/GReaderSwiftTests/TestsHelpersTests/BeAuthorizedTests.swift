import Nimble
import XCTest


class BeAuthorizedTests: XCTestCase {
    func test_BeAuthorized_WithValidAuthorizationValue() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("GoogleLogin auth=abc", forHTTPHeaderField: "Authorization")
        
        // Then
        // Valid <abc> value
        expect(request).to(beAuthorized(withAuthKey: "abc"))
        failsWithErrorMessage("expected to not equal <GoogleLogin auth=abc>, got <GoogleLogin auth=abc>") {
            expect(request).toNot(beAuthorized(withAuthKey: "abc"))
        }
        
        // Invalid <def> value
        failsWithErrorMessage("expected to equal <GoogleLogin auth=def>, got <GoogleLogin auth=abc>") {
            expect(request).to(beAuthorized(withAuthKey: "def"))
        }
        expect(request).toNot(beAuthorized(withAuthKey: "def"))
    }
    
    func test_BeAuthorized_WithInvalidAuthorizationValue() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("auth=abc", forHTTPHeaderField: "Authorization")
        
        // Then
        // Valid <abc> value
        failsWithErrorMessage("expected to equal <GoogleLogin auth=abc>, got <auth=abc>") {
            expect(request).to(beAuthorized(withAuthKey: "abc"))
        }
        expect(request).toNot(beAuthorized(withAuthKey: "abc"))
    }
    
    func test_BeAuthorized_WithNilRequest() {
        // Given
        let request: URLRequest? = nil
        
        // Then
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).to(beAuthorized(withAuthKey: "abc"))
        }
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).toNot(beAuthorized(withAuthKey: "abc"))
        }
    }
    
    func test_BeAuthorized_WithNoHTTPHeaderFields() {
        // Given
        let request = URLRequest(url: URL(string: "https://localhost/")!)
        
        // Then
        failsWithErrorMessage("expected to have <Authorization> HTTP header field, got <nil>") {
            expect(request).to(beAuthorized(withAuthKey: "abc"))
        }
        expect(request).toNot(beAuthorized(withAuthKey: "abc"))
    }
    
    func test_BeAuthorized_WithMissingAuthorizationHTTPHeaderField() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("a", forHTTPHeaderField: "x")
        request.setValue("b", forHTTPHeaderField: "y")
        request.setValue("c", forHTTPHeaderField: "z")
        
        // Then
        failsWithErrorMessage("expected to have <Authorization> HTTP header field, got <[x, y, z]>") {
            expect(request).to(beAuthorized(withAuthKey: "abc"))
        }
        expect(request).toNot(beAuthorized(withAuthKey: "abc"))
    }
}
