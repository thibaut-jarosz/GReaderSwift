@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class URLRequestTests: XCTestCase {
    
    // MARK: - Init
    
    func test_InitWithCredentialsPathAndQueryItems_ShouldSetCorrectURLAndAuthorizationHeader() {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api")!,
            username: "username",
            authKey: "abc"
        )
        let path = URLPath.clientLogin
        
        // When
        let result = URLRequest(
            credentials: credentials,
            path: path,
            queryItems: [URLQueryItem(name: "123", value: "456")]
        )
        
        // Then
        expect(result.url) == URL(string: "https://localhost/api/\(URLPath.clientLogin.rawValue)?123=456")!
        expect(result).to(beAuthorized(withAuthKey: "abc"))
    }
    
    // MARK: - SetURLEncodedPostForm
    
    func test_SetURLEncodedPostForm_ShouldConfigureTheRequest() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/api/")!)
        
        // When
        request.setURLEncodedPostForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ])
        
        // Then
        expect(request.httpMethod) == "POST"
        expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/x-www-form-urlencoded"
        expect(request.httpBody) == "abc=def&123=456".data(using: .utf8)
    }
    
    func test_SetURLEncodedPostForm_ShouldReplaceAlreadyConfiguredDataOfRequest() {
        // Given
        var request = URLRequest(url: URL(string: "https://localhost/api/")!)
        
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"key\":\"value\"}".data(using: .utf8)
        
        expect(request.httpMethod) == "PATCH"
        expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
        expect(request.httpBody) == "{\"key\":\"value\"}".data(using: .utf8)
        
        // When
        request.setURLEncodedPostForm([
            .init(name: "abc", value: "def"),
            .init(name: "123", value: "456")
        ])
        
        // Then
        expect(request.httpMethod) == "POST"
        expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/x-www-form-urlencoded"
        expect(request.httpBody) == "abc=def&123=456".data(using: .utf8)
    }
}
