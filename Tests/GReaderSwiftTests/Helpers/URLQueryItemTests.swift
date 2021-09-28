@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class URLQueryItemTests: XCTestCase {
    
    func test_JSONOutput_ShouldReturnACorrectlyConfiguredQueryItem() {
        // Given
        
        // When
        let result = URLQueryItem.jsonOutput
        
        // Then
        expect(result) == URLQueryItem(name: "output", value: "json")
    }
    
    func test_TokenFromCredentials_ShouldUseCachedTokenAndReturnACorrectlyConfiguredQuer() async throws {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api/")!,
            username: "username",
            authKey: "auth_key"
        )
        credentials.cachedTokenTestAccess = "some_cached_token"
        
        // When
        let result = try await URLQueryItem.token(from: credentials)
        
        // Then
        expect(result) == URLQueryItem(name: "T", value: "some_cached_token")
    }
    
    func test_TokenFromCredentials_ShouldMakeATokenRequestOnServerAndReturnACorrectlyConfiguredQueryItem_WhenCachedTokenIsNil() async throws {
        // Given
        let baseURL = URL(string: "https://localhost/api/")!
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        Mock(
            url: URL(string: URLPath.token.rawValue, relativeTo: baseURL)!,
            dataType: .json,
            statusCode: 200,
            data: [.get : "some_token".data(using: .utf8)!]
        ).register()
        
        // When
        let result = try await URLQueryItem.token(from: credentials)
        
        // Then
        expect(result) == URLQueryItem(name: "T", value: "some_token")
    }
    
}
