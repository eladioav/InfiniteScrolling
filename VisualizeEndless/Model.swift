//
//  Model.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//
import SwiftUI

class ImageObject {
    var name: String
    var scale: CGFloat
    
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

class Object<P: Equatable> {
    var content: P
    var next: Object?
    var previous: Object?
    
    init(content: P) {
        self.content = content
    }
}

class DoubleLinkedList<P: Equatable> {
    var top: Object<P>?
    var tail: Object<P>?
    var count: Int = 0
    
    private func createObject(with content: P) -> Object<P> {
        return Object(content: content)
    }
    
    func push(content: P) {
        defer { count += 1 }
        
        let newObject = createObject(with: content)
        guard let top = top else {
            self.top = newObject
            self.tail = newObject
            return
        }
        
        guard let tail = tail, top.content == tail.content else {
            top.next = newObject
            newObject.previous = top
            self.tail = top.next
            return
        }
        
        tail.next = newObject
        newObject.previous = tail
        self.tail = tail.next
    }
    
    func extendToRight() {
        guard let top = top, let tail = tail else { return }
        
        guard top.content != tail.content else { return }
        
        tail.previous?.next = nil
        tail.previous = nil
        
        tail.next = top
        top.previous = tail
        
        let temp = tail
        self.tail = top
        self.top = temp
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
}
