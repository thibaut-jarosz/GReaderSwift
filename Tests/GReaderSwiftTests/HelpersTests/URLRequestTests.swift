import XCTest
import Nimble

final class URLRequestTests: XCTestCase {
    func testHTTPBodyStreamStringWithValidString() {
        let data = "Some string".data(using: .utf8)!
        
        var request = URLRequest(url: URL(string: "https://localhost/")!)
        request.httpBodyStream = InputStream(data: data)
        
        expect(request.httpBodyStreamString) == "Some string"
    }
    
    func testHTTPBodyStreamStringWithEmptyData() {
        let request = URLRequest(url: URL(string: "https://localhost/")!)
        
        expect(request.httpBodyStreamString).to(beNil())
    }
}
