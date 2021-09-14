@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class URLRequestTests: XCTestCase {
    
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
    
}
