import Nimble
import XCTest

class HaveURLEncodedFormTests: XCTestCase {
    func test_HaveURLEncodedForm_WithValidContentTypeAndBody() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "abc=def&123=456".data(using: .utf8)
        
        // Then
        // Valid form value
        expect(request).to(haveURLEncodedForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ]))
        failsWithErrorMessage("expected to not have <abc=def&123=456> body, got <abc=def&123=456>") {
            expect(request).toNot(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        
        // Invalid form value
        failsWithErrorMessage("expected to have <123=456&abc=def> body, got <abc=def&123=456>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "123", value: "456"),
                .init(name: "abc", value: "def")
            ]))
        }
        expect(request).toNot(haveURLEncodedForm([
            .init(name: "123", value: "456"),
            .init(name: "abc", value: "def")
        ]))
    }
    
    func test_HaveURLEncodedForm_WithInvalidContentTypeValue() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "abc=def&123=456".data(using: .utf8)
        
        // Then
        failsWithErrorMessage("expected to have <Content-Type> HTTP header value equal to <application/x-www-form-urlencoded>, got <application/json>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        expect(request).toNot(haveURLEncodedForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ]))
    }
    
    func test_HaveURLEncodedForm_WithNilRequest() {
        // Given
        let request: URLRequest? = nil
        
        // Then
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        failsWithErrorMessageForNil("expected to have request, got <nil>") {
            expect(request).toNot(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
    }
    
    func test_HaveURLEncodedForm_WithNoHTTPHeaderFields() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.allHTTPHeaderFields = nil
        request.httpBody = "abc=def&123=456".data(using: .utf8)
        
        // Then
        failsWithErrorMessage("expected to have <Content-Type> HTTP header, got <[]>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        expect(request).toNot(haveURLEncodedForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ]))
    }
    
    func test_HaveURLEncodedForm_WithMissingContentTypeHTTPHeaderField() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("a", forHTTPHeaderField: "x")
        request.setValue("b", forHTTPHeaderField: "y")
        request.setValue("c", forHTTPHeaderField: "z")
        request.httpBody = "abc=def&123=456".data(using: .utf8)
        
        // Then
        failsWithErrorMessage("expected to have <Content-Type> HTTP header, got <[x, y, z]>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        expect(request).toNot(haveURLEncodedForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ]))
    }
    
    func test_HaveURLEncodedForm_WithMissingBody() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Then
        failsWithErrorMessage("expected to have <abc=def&123=456> body, got <nil>") {
            expect(request).to(haveURLEncodedForm([
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456")
            ]))
        }
        expect(request).toNot(haveURLEncodedForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ]))
    }
}
