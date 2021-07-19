import XCTest
import Nimble

final class StringTests: XCTestCase {
    func testURLQueryItemsWithCorrectlyFormattedString() {
        let string = "a=b&c=d"
        let result = string.urlQueryItems
        
        expect(result.count) == 2
        expect(result).to(contain([
            .init(name: "a", value: "b"),
            .init(name: "c", value: "d"),
        ]))
    }
    
    func testURLQueryItemsWithEmptyString() {
        let string = ""
        let result = string.urlQueryItems
        
        expect(result).to(beEmpty())
    }
    
    func testURLQueryItemsWithURLString() {
        let string = "http://localhost/test?a=b"
        let result = string.urlQueryItems
        
        expect(result) == [
            .init(name: "http://localhost/test?a", value: "b")
        ]
    }
}
