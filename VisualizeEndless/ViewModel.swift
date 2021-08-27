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
    @Published var yDraggingPosition: CGFloat = 0.0
    private var subscriptions = Set<AnyCancellable>()
    
    let height: CGFloat = 160
    let width: CGFloat = 160
    
    init() {
        let objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]

        data = DoubleLinkedList<P>()
        objects.forEach({ data.push(content: $0 as! P) })
        
        $yDraggingPosition
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { position in
                if position == 0.0 { return }
                self.data.move(toRight: position > 0.0 ? false : true)
            })
            .store(in: &self.subscriptions)
    }
    
    deinit {
        subscriptions = []
    }
}
