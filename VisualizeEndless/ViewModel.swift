//
//  ViewModel.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 18/08/21.
//

import Combine
import SwiftUI

class ViewModel<P: Equatable & DataProvider>: ObservableObject {
    @Published var data: DoubleLinkedList<P>
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var topIsVisible: Bool = false
    @Published var tailIsVisible: Bool = false
    @Published var yDraggingPosition: CGFloat = 0
    @Published var currentObjectState: (Object<P>, Bool)?
    @Published var nextObject: Object<P>?
    
    let minYDragging: CGFloat = 10
    let height: CGFloat = 160
    let width: CGFloat = 160
    
    init() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        data = DoubleLinkedList<P>()
        objects.forEach({ data.push(content: $0 as! P) })
        
        $currentObjectState
            .sink(receiveValue: { object in
                guard let object = object else { return }
                object.0.isVisible = object.1
//                self.set(listPosition: self.data.position(of: object.0), isVisible: object.1)
            })
            .store(in: &self.subscriptions)
        
        $yDraggingPosition
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { position in
                
                if position == 0.0 { return }
                
                if position > 0.0 {
                    guard let currentObject = self.data.getLeftObject() else {
                        self.data.moveFarLeft()
                        self.data = self.data
                        return
                    }
                    
                    self.nextObject = currentObject
                } else {
                    guard let currentObject = self.data.getRightObject() else {
                        self.data.moveFarRight()
                        self.data = self.data
                        return
                    }
                    self.nextObject = currentObject
                }
            })
            .store(in: &self.subscriptions)

        /*
        $topIsVisible
            .combineLatest($yDraggingPosition)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                guard result.0 == true && result.1 > 0.0 else { return }
                self.yDraggingPosition = 0.0
                //self.moveFarLeft()
            })
            .store(in: &self.subscriptions)
            
        $tailIsVisible
            .combineLatest($yDraggingPosition)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                guard result.0 == true && result.1 < 0.0 else { return }
                self.yDraggingPosition = 0.0
                self.moveFarRight()
            })
            .store(in: &self.subscriptions)
*/
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
//        set(listPosition: data.position(of: object), isVisible: isVisible)
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
