import XCTest
import Nimble

final class URLRequestTestsHelperTests: XCTestCase {
    func test_HTTPBodyStreamString_ShouldReturnString_WhenHTTPBodyStreamContainsDataConvertedFromString() {
        // Given
        let data = "Some string".data(using: .utf8)!
        
        // When
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.httpBodyStream = InputStream(data: data)
        
        // Then
        expect(request.httpBodyStreamString) == "Some string"
    }
    
    func test_HTTPBodyStreamString_ShouldReturnNil_WhenHTTPBodyStreamDoesNotContainAnyData() {
        // Given
        
        // When
        let request = URLRequest(url: URL(string: "https://localhost/")!)
        
        // Then
        expect(request.httpBodyStreamString).to(beNil())
    }
}
