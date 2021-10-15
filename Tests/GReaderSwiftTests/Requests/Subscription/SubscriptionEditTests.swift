@testable import GReaderSwift
@testable import Mocker
import Nimble
import XCTest

final class SubscriptionEditTests: XCTestCase {
    
    let baseURL = URL(string: "https://localhost/api/")!
    let subscription = Subscription(
        id: "feed/1",
        title: "Feed 1",
        categories: [
            .init(id: "user/-/label/Cat 1", label: "Cat 1")
        ],
        url: URL(string: "https://site1/feed.xml")!,
        htmlURL: URL(string: "https://site1/")!,
        iconURL: URL(string: "https://site1/icon.jpg")!
    )
    
    /// Helper function to create a mock
    /// - Parameter statusCode: response status code
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200) -> Mock {
        let url = URL(string: "reader/api/0/subscription/edit", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .post : "ignored response".data(using: .utf8)!,
        ])
    }
    
    /// Helper function to create a mock for token request
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func tokenMock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: URLPath.token.rawValue, relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_Edit_ShouldSendValidHeadersAndPostData() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        tokenMock(response: "some_token".data(using: .utf8)!).register()
        var mock = mock()
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/reader/api/0/subscription/edit")!
            expect(request.httpMethod) == "POST"
            expect(request).to(beAuthorized(withAuthKey: "auth_key"))
            expect(request).to(haveURLEncodedForm([
                .init(name: "T", value: "some_token"),
                .init(name: "s", value: "feed/1"),
                .init(name: "ac", value: "edit"),
                .init(name: "abc", value: "def"),
                .init(name: "123", value: "456"),
            ]))
        }
        mock.register()
        
        // When
        try await subscription.edit(
            using: credentials,
            action: .edit,
            additionalParams: .init(name: "abc", value: "def"), .init(name: "123", value: "456")
        )
    }
    
    func test_Edit_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        mock(statusCode: 500).register()
        tokenMock(response: "some_token".data(using: .utf8)!).register()
        
        // When
        do {
            try await subscription.edit(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Edit_ShouldThrowAServerResponseError_WhenThereIsAServerErrorWithTokenRequest() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        mock().register()
        tokenMock(statusCode: 500, response: Data()).register()
        
        // When
        do {
            try await subscription.edit(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Edit_ShouldNotThrowAServerResponseError_WhenThereIsAServerErrorWithTokenRequestAndTokenIsAlreadyCached() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        credentials.cachedTokenTestAccess = "some_token"
        mock().register()
        tokenMock(statusCode: 500, response: Data()).register()
        
        // When/Then
        try await subscription.edit(using: credentials)
    }
}
