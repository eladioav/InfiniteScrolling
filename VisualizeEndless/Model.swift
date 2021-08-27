//
//  Model.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//
import SwiftUI

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
        return lhs.id == rhs.id
    }
}

class DoubleLinkedList<P: Equatable & DataProvider> {
    private var top: Object<P>?
    private var tail: Object<P>?
    var objectCount: Int = 0
    
    private func createObject(with content: P) -> Object<P> {
        return Object(content: content)
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
    
    private func addObjectToTail() {
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
    
    private func addObjectToTop() {
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
    
    func move(toRight: Bool) {
        toRight ? addObjectToTail() : addObjectToTop()
    }
    
    func getNotVisibleObject(toRight: Bool) ->  Object<P>? {
        guard var currentObject = toRight ? tail : top else { return nil }
        
        while currentObject.isVisible  != true {
            guard let contiguousObject = toRight ?
                    currentObject.previous :
                    currentObject.next  else { break }
            
            currentObject = contiguousObject
        }
        
        guard let contiguousObject = toRight ?
                currentObject.next :
                currentObject.previous else {
            
            toRight ? addObjectToTail() : addObjectToTop()
            return nil
        }
        return contiguousObject
    }
}

extension DoubleLinkedList: RandomAccessCollection {
    typealias Element = Object
    typealias Index = Int
    typealias Indices = CountableRange<Int>
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return objectCount }
    public var count: Int { return distance(from: startIndex, to: endIndex) }
    
    public func index(after i: Int) -> Int { return i + 1 }
    
    public func index(before i: Int) -> Int { return i - 1 }
    
    public subscript(position: Int) -> Element<P> {
        get {
            var currentObject = top
            guard position > 0 else { return currentObject! }
            for _ in 1...position { currentObject = currentObject?.next }
            return currentObject!
        }
          
        set { top = newValue }
    }
}
