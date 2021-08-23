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
    let subjectTopVisible = PassthroughSubject<(ListPosition,Bool), Never>()
    let subjectTailVisible = PassthroughSubject<(ListPosition,Bool), Never>()
    let subjectYDraggingPosition = PassthroughSubject<CGFloat, Never>()
    
    @Published var topIsVisible: Bool = false
    @Published var tailIsVisible: Bool = false
    @Published var yDraggingPosition: CGFloat = 0
    @Published var currentObject: ImageObject?
    
    let minYDragging: CGFloat = 10
    let height: CGFloat = 160
    let width: CGFloat = 160
    
    init() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
        data = DoubleLinkedList<ImageObject>()
        objects.forEach({ data.push(content: $0) })
        
        $currentObject
            .sink(receiveValue: { object in
                print("Current object:\(object.name)")
            })
            .store(in: &self.subscriptions)
        
        $yDraggingPosition
            .map{ self.setDragging(x: $0) }
            .sink(receiveValue: { result in
                print("Result y:\(result)")
            })
            .store(in: &self.subscriptions)
        
//        $tailIsVisible
//            .merge(with: $topIsVisible)
        
        subjectTopVisible
            .combineLatest(subjectTailVisible)
//            .append(subjectTailVisible)
//            .merge(with: subjectTailVisible)
            .sink(receiveValue: { result in
                print("Result:\(result)")
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
    
    func setVisibility(of object: ImageObject, isVisible: Bool) {
        set(listPosition: data.position(of: object), isVisible: isVisible)
    }
    
    private func set(listPosition: ListPosition, isVisible: Bool) {
        switch listPosition {
        case .top:
            topIsVisible = isVisible
            subjectTopVisible.send((listPosition,isVisible))
            break
        case .tail:
            tailIsVisible = isVisible
            subjectTailVisible.send((listPosition,isVisible))
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
