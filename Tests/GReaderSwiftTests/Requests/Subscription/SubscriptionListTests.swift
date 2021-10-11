@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class SubscriptionListTests: XCTestCase {
    
    let baseURL = URL(string: "https://localhost/api/")!
    let mockedResponse = """
        {
            "subscriptions": [
                {
                    "id": "feed/1",
                    "title": "Feed 1",
                    "categories": [
                        {
                            "id": "user/-/label/Cat 1",
                            "label": "Cat 1"
                        }
                    ],
                    "url": "https://site1/feed.xml",
                    "htmlUrl": "https://site1/",
                    "iconUrl": "https://site1/icon.jpg"
                },
                {
                    "id": "feed/4",
                    "title": "Feed 4",
                    "categories": [],
                },
            ]
        }
        """
    
    /// Helper function to create a mock
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: "reader/api/0/subscription/list?output=json", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_List_ShouldReturnSubscriptionList_WhenServerRespondsWithValidData() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        // When
        let result = try await Subscription.list(using: credentials)
        
        // Then
        expect(result) == [
            Subscription(
                id: "feed/1",
                title: "Feed 1",
                categories: [
                    .init(id: "user/-/label/Cat 1", label: "Cat 1")
                ],
                url: URL(string: "https://site1/feed.xml")!,
                htmlURL: URL(string: "https://site1/")!,
                iconURL: URL(string: "https://site1/icon.jpg")!
            ),
            Subscription(
                id: "feed/4",
                title: "Feed 4",
                categories: [],
                url: nil,
                htmlURL: nil,
                iconURL: nil
            )
        ]
    }
        
    func test_List_ShouldSendValidAuthorizationHeaderInRequest() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        var mock = mock(response: mockedResponse.data(using: .utf8)!)
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/reader/api/0/subscription/list?output=json")!
            expect(request).to(beAuthorized(withAuthKey: "auth_key"))
        }
        mock.register()
        
        // When
        let _ = try await Subscription.list(using: credentials)
    }
    
    func test_List_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        
        // When
        let mock = mock( statusCode: 500, response: mockedResponse.data(using: .utf8)!)
        mock.register()

        do {
            let _ = try await Subscription.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_List_ShouldThrowAnInvalidDataResponseError_WhenResponseIsEmpty() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = "".data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await Subscription.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
    func test_List_ShouldThrowAnInvalidDataResponseError_WhenResponseIsNotValidJSON() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
        {
            "subscriptions": [
                {
                    "id": "feed/1",
                    "title": "Feed 1",
                    "categories": [
                        {
                            "id": "user/-/label/Cat 1",
                            "label": "Cat 1"
                        }
                    ],
                    "url": "https://site1/feed.xml",
                    "htmlUrl": "https://site1/",
                    "iconUrl": "ttps://site1/icon.jpg"
                }
        """.data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await Subscription.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
    func test_List_ShouldThrowAnInvalidDataResponseError_WhenResponseJSONIsMissingARequiredKey() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
        {
            "subscriptions": [
                {
                    "id": "feed/1",
                    "title": "Feed 1",
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await Subscription.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
}
