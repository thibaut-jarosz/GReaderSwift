import Nimble
import XCTest

class HaveHTTPHeaderFieldTests: XCTestCase {
    func test_HaveHTTPHeaderField_WithFieldPresentInHeader() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("abc", forHTTPHeaderField: "xyz")
        
        // Then
        // Valid <abc> value
        expect(request).to(have(httpHeaderField: "xyz", at: "abc"))
        failsWithErrorMessage("expected to not have <xyz> HTTP header value equal to <abc>, got <abc>") {
            expect(request).toNot(have(httpHeaderField: "xyz", at: "abc"))
        }
        
        // Invalid <def> value
        failsWithErrorMessage("expected to have <xyz> HTTP header value equal to <def>, got <abc>") {
            expect(request).to(have(httpHeaderField: "xyz", at: "def"))
        }
        expect(request).toNot(have(httpHeaderField: "xyz", at: "def"))
    }
    
    func test_HaveHTTPHeaderField_WithNilRequest() {
        // Given
        let request: URLRequest? = nil
        
        // Then
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).to(have(httpHeaderField: "xyz", at: "abc"))
        }
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).toNot(have(httpHeaderField: "xyz", at: "abc"))
        }
    }
    
    func test_HaveHTTPHeaderField_WithNoHTTPHeaderFields() {
        // Given
        let request = URLRequest(url: URL(string: "https://localhost/")!)
        
        // Then
        failsWithErrorMessage("expected to have <xyz> HTTP header, got <[]>") {
            expect(request).to(have(httpHeaderField: "xyz", at: "abc"))
        }
        expect(request).toNot(have(httpHeaderField: "xyz", at: "abc"))
    }
    
    func test_HaveHTTPHeaderField_WithMissingAuthorizationHTTPHeaderField() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("a", forHTTPHeaderField: "x")
        request.setValue("b", forHTTPHeaderField: "y")
        request.setValue("c", forHTTPHeaderField: "z")
        
        // Then
        failsWithErrorMessage("expected to have <xyz> HTTP header, got <[x, y, z]>") {
            expect(request).to(have(httpHeaderField: "xyz", at: "abc"))
        }
        expect(request).toNot(have(httpHeaderField: "xyz", at: "abc"))
    }
}
