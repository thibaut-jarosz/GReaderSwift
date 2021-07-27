import XCTest
@testable import GReaderSwift
import Mocker
import Nimble

final class URLRequestTests: XCTestCase {
    
    func test_InitWithCredentials_ShouldSetAuthenticationHeader() {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/")!,
            username: "username",
            authKey: "abc"
        )
        
        // When
        let result = URLRequest(url: URL(string: "https://localhost/path")!, credentials: credentials)
        
        // Then
        expect(result.allHTTPHeaderFields?["Authorization"]) == "GoogleLogin auth=abc"
    }
    
}
