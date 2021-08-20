//
//  ViewModel.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 18/08/21.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var data: DoubleLinkedList<ImageObject>
    var topIsVisible: Bool = false
    var tailIsVisible: Bool = false
    var yDraggingPosition: CGFloat = 0
    let minYDragging: CGFloat = 10
    
    init() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        data = DoubleLinkedList<ImageObject>()
        objects.forEach({ data.push(content: $0) })
    }
    
    func setDragging(y: CGFloat) {
        guard abs(y) >= 10 else { return }
        print("Set dragging:\(y)")
        if topIsVisible && y.sign == .plus {
            moveFarLeft()
            return
        }
        
        if tailIsVisible && y.sign == .minus {
            moveFarRight()
            return
        }
    }
    
    func setVisibility(of object: ImageObject, isVisible: Bool) {
        set(listPosition: data.position(of: object), isVisible: isVisible)
    }
    
    private func set(listPosition: ListPosition, isVisible: Bool) {
        switch listPosition {
        case .top:
            topIsVisible = isVisible
            break
        case .tail:
            tailIsVisible = isVisible
            break
        default: ()
        }
    }
    
    func extendToRight() {
        data.extendToRight()
        data = data
    }
    
    func extendToLeft() {
        data.extendToLeft()
        data = data
    }
    
    func moveFarLeft() {
        data.moveFarLeft()
        data = data
    }
    
    func moveFarRight() {
        data.moveFarRight()
        data = data
    }
}
