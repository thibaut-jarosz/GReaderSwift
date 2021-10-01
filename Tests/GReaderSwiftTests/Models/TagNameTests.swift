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
    
    // MARK: - SetName
    
    func test_SetName_ShouldUdpateTagID_WhenTagTypeIsFolder() throws {
        // Given
        var tag = Tag(id: "user/-/label/Some Folder", type: "folder")
        let newName = "Another Folder"
        
        // When
        try tag.setName(newName)
        
        // Then
        expect(tag.name) == newName
        expect(tag) == Tag(id: "user/-/label/Another Folder", type: "folder")
    }
    
    func test_SetName_ShouldThrowCannotRenameTag_WhenLabelCannotBeFoundInIDAndTypeIsFolder() {
        // Given
        var tag = Tag(id: "user/-/state/com.google/starred", type: "folder")

        // When
        expect { try tag.setName("abc") }
        
        // Then
        .to(throwError(errorType: GReaderError.self) { error in
            expect(error) == .cannotRenameTag
        })
    }
    
    func test_SetName_ShouldThrowCannotRenameTag_WhenTypeIsNotFolder() {
        // Given
        var tag = Tag(id: "user/-/label/Some Folder", type: "notfolder")
        
        // When
        expect { try tag.setName("abc") }
        
        // Then
        .to(throwError(errorType: GReaderError.self) { error in
            expect(error) == .cannotRenameTag
        })
    }
    
    func test_SetName_ShouldThrowCannotRenameTag_WhenTypeIsNil() {
        // Given
        var tag = Tag(id: "user/-/label/Some Folder", type: nil)
        
        // When
        expect { try tag.setName("abc") }
        
        // Then
        .to(throwError(errorType: GReaderError.self) { error in
            expect(error) == .cannotRenameTag
        })
    }
    
}
