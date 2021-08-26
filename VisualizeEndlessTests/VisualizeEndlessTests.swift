//
//  VisualizeEndlessTests.swift
//  VisualizeEndlessTests
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import XCTest

class VisualizeEndlessTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testObjects() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        
        let list = DoubleLinkedList<ImageObject>()
        objects.forEach({ list.push(content: $0) })
        
        //Check count and top and tail
        XCTAssert(objects.count == 10)
        XCTAssert(list[0].content.name == "trash")
        XCTAssert(list[9].content.name == "power")
        
        //Move to the right of tail
        list[9].isVisible = true
        _ = list.getNotVisibleObject(toRight: true)
        list[8].isVisible = false
        XCTAssert(list[0].content.name == "pencil.tip")
        XCTAssert(list[9].content.name == "trash")
        
        //Move to the left of top
        list[0].isVisible = true
        _ = list.getNotVisibleObject(toRight: false)
        list[1].isVisible = false
        XCTAssert(list[0].content.name == "trash")
        
        //Move to the right of top
        list[0].isVisible = true
        let nextObject = list.getNotVisibleObject(toRight: true)
        list[0].isVisible = false
        XCTAssert(nextObject?.content.name == "pencil.tip")
        
        //Move to the left of bookmark
        list[8].isVisible = true
        let previousObject = list.getNotVisibleObject(toRight: false)
        list[8].isVisible = false
        XCTAssert(previousObject?.content.name == "book")
        
    }

}
