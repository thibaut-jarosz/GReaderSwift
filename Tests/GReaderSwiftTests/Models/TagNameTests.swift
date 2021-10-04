@testable import GReaderSwift
import Nimble
import XCTest

final class TagNameTests: XCTestCase {
    
    func test_Name_ShouldReturnValueAfterLabelInID() {
        // Given
        let tag = Tag(id: "user/-/label/Some Name", type: "folder")
        
        // When
        let result = tag.name
        
        // Then
        expect(result) == "Some Name"
    }
    
    func test_Name_ShouldReturnNil_WhenLabelCannotBeFoundInID() {
        // Given
        let tag = Tag(id: "user/-/state/com.google/starred", type: "folder")
        
        // When
        let result = tag.name
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_Name_ReturnValueAfterLabelInID_WhenTypeIsNil() {
        // Given
        let tag = Tag(id: "user/-/label/Some Name", type: nil)
        
        // When
        let result = tag.name
        
        // Then
        expect(result) == "Some Name"
    }
    
    // MARK: - SetName
    
    func test_SetName_ShouldUdpateTagID_WhenTagIDContainsALabel() throws {
        // Given
        var tag = Tag(id: "user/-/label/Some Name", type: "folder")
        let newName = "Another Name"
        
        // When
        try tag.setName(newName)
        
        // Then
        expect(tag.name) == newName
        expect(tag) == Tag(id: "user/-/label/Another Name", type: "folder")
    }
    
    func test_SetName_ShouldThrowCannotRenameTag_WhenLabelCannotBeFoundInID() {
        // Given
        var tag = Tag(id: "user/-/state/com.google/starred", type: "folder")

        // When
        expect { try tag.setName("abc") }
        
        // Then
        .to(throwError(errorType: GReaderError.self) { error in
            expect(error) == .cannotRenameTag
        })
    }
    
}
