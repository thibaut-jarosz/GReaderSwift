@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class URLRequestSendTests: XCTestCase {
    
    /// Helper function to create a mock
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: "https://localhost/api/")!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_Send_ShouldSendRequestAndReturnResult() async throws {
        // Given
        let request = URLRequest(url: URL(string: "https://localhost/api/")!)
        var mock = mock(response: "some response".data(using: .utf8)!)
        
        mock.onRequest = { request, _ in
            // Then
            expect(request) == request
        }
        mock.register()
        
        // When
        let result = try await request.send()
        
        // Then
        expect(result) == "some response".data(using: .utf8)!
    }
    
    func test_Send_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let request = URLRequest(url: URL(string: "https://localhost/api/")!)
        
        // When
        mock( statusCode: 500, response: Data()).register()
        
        do {
            let _ = try await request.send()
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_SendWithJSONResponse_ShouldReturnDecodedData() async throws {
        // Given
        struct Response: Codable, Equatable {
            var title: String
        }
        let request = URLRequest(url: URL(string: "https://localhost/api/")!)
        mock(response: "{ \"title\": \"some title\" }".data(using: .utf8)!).register()
        
        // When
        let result = try await request.send(withJSONResponse: Response.self)
        
        // Then
        expect(result) == Response(title: "some title")
    }
    
    func test_SendWithJSONResponse_ShouldThrowAnInvalidDataResponse_WhenJSONCannotBeDecoded() async throws {
        // Given
        struct Response: Codable {
            var name: String
        }
        let request = URLRequest(url: URL(string: "https://localhost/api/")!)
        mock(response: "{ \"title\": \"some title\" }".data(using: .utf8)!).register()
        
        // When
        do {
            let _ = try await request.send(withJSONResponse: Response.self)
            XCTFail("Error should have been thrown")
        }
        
        // Then
        catch {
            expect(error as? GReaderError) == .invalidDataResponse("{ \"title\": \"some title\" }".data(using: .utf8)!)
        }
    }
    
    func test_SendWithJSONResponse_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        struct Response: Codable {
            var title: String
        }
        let request = URLRequest(url: URL(string: "https://localhost/api/")!)
        
        // When
        mock( statusCode: 500, response: Data()).register()
        
        do {
            let _ = try await request.send(withJSONResponse: Response.self)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
}
