//
//  ContentView.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.data, id:\.name) { object in
                    Image(systemName: object.name)
                        .resizable()
                        .scaledToFit()
                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .onAppear(perform: {
                            viewModel.setVisibility(of: object, isVisible: true)
                            print("Appear:\(object.name)")
                        })
                        .onDisappear(perform: {
                            viewModel.setVisibility(of: object, isVisible: false)
                            print("Disappear:\(object.name)")
                        })
                }
            }
            .frame(height: 100)
        }
//        .simultaneousGesture(
//            DragGesture()
//                .onChanged({ action in
//                    print("Drag :\(action.translation.height)")
//                    viewModel.setDragging(y: action.translation.height)
//                })
//                .onEnded({ action in
//                    print("Ended Long")
//                })
//        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
