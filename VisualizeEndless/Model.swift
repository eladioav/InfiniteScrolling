//
//  Model.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//
import SwiftUI

enum ListPosition {
    case top
    case tail
    case other
}

protocol DataProvider {
    var name: String { get set }
    var id: UUID { get }
}

class ImageObject: DataProvider {
    var name: String
    var scale: CGFloat
    var id: UUID = UUID()
    
    init(name: String, scale: CGFloat = 1.0) {
        self.name = name
        self.scale = scale
    }
}

extension ImageObject: Equatable {
    static func == (lhs: ImageObject, rhs: ImageObject) -> Bool {
        return lhs.name == rhs.name
    }
}

class Object<P: Equatable & DataProvider> {
    var content: P
    var next: Object?
    var previous: Object?
    var isVisible: Bool = false
    let id: UUID = UUID()
    
    init(content: P) {
        self.content = content
    }
}

extension Object: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Object<P>, rhs: Object<P>) -> Bool {
        print("On Receive compare: \(lhs.content.name) - \(rhs.content.name)")
        return lhs.id == rhs.id
    }
}

class DoubleLinkedList<P: Equatable & DataProvider> {
    var top: Object<P>?
    var tail: Object<P>?
    var objectCount: Int = 0
    
    private func createObject(with content: P) -> Object<P> {
        return Object(content: content)
    }
    
    func position(of object: P) -> ListPosition {
        if object.name == top?.content.name { return .top }
        if object.name == tail?.content.name { return .tail }
        return .other
    }
    
    func push(content: P) {
        defer { objectCount += 1 }
        
        let newObject = createObject(with: content)
        guard let top = top else {
            self.top = newObject
            self.tail = newObject
            return
        }
        
        guard let tail = tail else {
            top.next = newObject
            newObject.previous = top
            self.tail = top.next
            return
        }
        
        tail.next = newObject
        newObject.previous = tail
        self.tail = tail.next
    }
    
    func moveFarRight() {
        guard let top = top, let tail = tail else { return }
        guard top.content != tail.content else { return }
        
        let temp = top
        self.top = top.next
        self.top?.previous = nil
        
        temp.next = nil
        tail.next = temp
        temp.previous = tail
        self.tail = temp
    }
    
    func moveFarLeft() {
        guard let top = top, let tail = tail else { return }
        guard top.content != tail.content else { return }
        
        let temp = tail
        tail.previous?.next = nil
        self.tail = tail.previous
        
        temp.previous = nil
        temp.next = top
        top.previous = temp
        self.top = temp
    }
    
    func extendToRight() {
        guard let top = top, let tail = tail else { return }
        
        guard top.content != tail.content else { return }
        
        let temp = tail.previous
        tail.previous?.next = nil
        tail.previous = nil
        
        tail.next = top
        top.previous = tail
        
        self.top = tail
        self.tail = temp
    }
    
    func extendToLeft() {
        guard let top = top, let tail = tail else { return }
        
        guard top.content != tail.content else { return }
        
        let temp = top.next
        temp?.previous = nil
        top.next = nil
        
        top.previous = tail
        tail.next = top
        
        self.tail = top
        self.top = temp
    }
    
    func run() {
        guard let top = top else {
            return
        }
        
        var current: Object? = top
        while current != nil {
            guard let imageObject = current?.content as? ImageObject else { continue }
            print(imageObject.name)
            current = current?.next
        }
    }
    
    func getLeftObject() -> Object<P>? {
        guard var currentObject = top else { return nil }
        while currentObject.isVisible  != true {
            guard let nextObject = currentObject.next else { break }
            currentObject = nextObject
        }
        
        guard let previousObject = currentObject.previous else {
            return nil
//            moveFarLeft()
//            return top?.content
        }
        return previousObject
    }
    
    func getRightObject() -> Object<P>? {
        guard var currentObject = tail else { return nil }
        while currentObject.isVisible  != true {
            guard let previousObject = currentObject.previous else { break }
            currentObject = previousObject
        }
        
        guard let nextObject = currentObject.next else {
            return nil
//            moveFarRight()
//            return tail?.content
        }
        return nextObject
    }
}

extension DoubleLinkedList: RandomAccessCollection {
//    typealias Element = ImageObject
    typealias Element = Object
    typealias Index = Int
    typealias Indices = CountableRange<Int>
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return objectCount }
    public var count: Int { return distance(from: startIndex, to: endIndex) }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public func index(before i: Int) -> Int {
        return i - 1    
    }
    
    public subscript(position: Int) -> Element<P> {
        get {
            var currentObject = top
            guard position > 0 else { return currentObject! }
            for _ in 1...position { currentObject = currentObject?.next }
            return currentObject!
        }
          
        set { top = newValue }
    
        /*
      get {
        var currentObject = top
        guard position > 0 else { return currentObject?.content as! DoubleLinkedList<P>.Element }
        for _ in 1...position { currentObject = currentObject?.next }
        return currentObject?.content as! DoubleLinkedList<P>.Element
      }
        
      set { top?.content = newValue as! P }
 */
    }
}
