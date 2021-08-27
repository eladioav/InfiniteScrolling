//
//  VisualizeEndlessTests.swift
//  VisualizeEndlessTests
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import XCTest

class VisualizeEndlessTests: XCTestCase {
    
    func testObjects() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        
        let list = DoubleLinkedList<ImageObject>()
        objects.forEach({ list.push(content: $0) })
        
        //Check count and top and tail
        XCTAssert(objects.count == 10)
        XCTAssert(list[0]!.content.name == "trash")
        XCTAssert(list[9]!.content.name == "power")
        
        //Move to the right
        list.move(toRight: true)
        XCTAssert(list[0]!.content.name == "pencil.tip")
        XCTAssert(list[9]!.content.name == "trash")
        
        //Move to the left
        list.move(toRight: false)
        XCTAssert(list[0]!.content.name == "trash")
        XCTAssert(list[9]!.content.name == "power")
        
        //Move to the left
        list.move(toRight: false)
        XCTAssert(list[0]!.content.name == "power")
        XCTAssert(list[9]!.content.name == "bookmark")
    }

}
