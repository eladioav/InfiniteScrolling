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
        XCTAssert(objects.count == 10)
        XCTAssert(list.top?.content.name == "trash")
        XCTAssert(list.tail?.content.name == "power")
        
        list.run()
        print("***************** :\(list.top?.content.name) - \(list.tail?.content.name)")
        list.extendToLeft()
        XCTAssert(objects.count == 10)
        XCTAssert(list.top?.content.name == "pencil.tip")
        XCTAssert(list.tail?.content.name == "trash")
        
        list.run()
        print("***************** :\(list.top?.content.name) - \(list.tail?.content.name)")
        list.extendToRight()
        XCTAssert(objects.count == 10)
        XCTAssert(list.top?.content.name == "trash")
        XCTAssert(list.tail?.content.name == "power")
        list.run()
        print("***************** :\(list.top?.content.name) - \(list.tail?.content.name)")
        
    }

}
