@testable import GReaderSwift
import Nimble
import XCTest

final class TagNameTests: XCTestCase {
    
    func test_Name_ShouldReturnValueAfterLabelInID_WhenTagTypeIsFolder() {
        // Given
        let tag = Tag(id: "user/-/label/Some Folder", type: "folder")
        
        // When
        let result = tag.name
        
        // Then
        expect(result) == "Some Folder"
    }
    
    func test_Name_ShouldReturnNil_WhenLabelCannotBeFoundInIDAndTypeIsFolder() {
        // Given
        let tag = Tag(id: "user/-/state/com.google/starred", type: "folder")
        
        // When
        let result = tag.name
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_Name_ShouldReturnNil_WhenTypeIsNotFolder() {
        // Given
        let tag = Tag(id: "user/-/label/Some Folder", type: "notfolder")
        
        // When
        let result = tag.name
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_Name_ShouldReturnNil_WhenTypeIsNil() {
        // Given
        let tag = Tag(id: "user/-/label/Some Folder", type: nil)
        
        // When
        let result = tag.name
        
        // Then
        expect(result).to(beNil())
    }
    
}
