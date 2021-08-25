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
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var topIsVisible: Bool = false
    @Published var tailIsVisible: Bool = false
    @Published var yDraggingPosition: CGFloat = 0
    @Published var currentObjectState: (ImageObject, Bool)?
    @Published var nextObject: String = ""
    
    let minYDragging: CGFloat = 10
    let height: CGFloat = 160
    let width: CGFloat = 160
    
    init() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        data = DoubleLinkedList<ImageObject>()
        objects.forEach({ data.push(content: $0) })
        
        $currentObjectState
            .sink(receiveValue: { object in
                guard let object = object else { return }
                self.set(listPosition: self.data.position(of: object.0), isVisible: object.1)
            })
            .store(in: &self.subscriptions)
        
        $topIsVisible
            .combineLatest($yDraggingPosition)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                guard result.0 == true && result.1 > 0.0 else { return } // >= self.minYDragging else { return }
                self.yDraggingPosition = 0.0
                //self.moveFarLeft()
                self.nextObject = "folder.circle"
            })
            .store(in: &self.subscriptions)
            
        $tailIsVisible
            .combineLatest($yDraggingPosition)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                guard result.0 == true && result.1 < 0.0 else { return } //<= -self.minYDragging else { return }
                self.yDraggingPosition = 0.0
                self.moveFarRight()
                self.nextObject = "Move Right"
            })
            .store(in: &self.subscriptions)

    }
    
    private func setDragging(x: CGFloat) -> String {
        guard abs(x) >= 10 else { return "None" }
        print("Set dragging:\(x)")
        if topIsVisible && x.sign == .plus {
            moveFarLeft()
            return "FarLeft"
        }
        
        if tailIsVisible && x.sign == .minus {
            moveFarRight()
            return "FarRight"
        }
        
        return "None"
    }
    
    private func setVisibility(of object: ImageObject, isVisible: Bool) {
        object.isVisible = isVisible
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
    
    deinit {
        subscriptions = []
    }
}
