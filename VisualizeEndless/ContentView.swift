//
//  ContentView.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @GestureState var isDetecting = CGSize.zero
    
    var body: some View {
        VStack {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: viewModel.width/2) {
                ForEach(viewModel.data, id:\.name) { object in
                    Image(systemName: object.name)
                        .resizable()
                        .scaledToFit()
                        .frame(height: viewModel.height)
                        .onAppear(perform: {
                            viewModel.setVisibility(of: object, isVisible: true)
                            viewModel.currentObject = object
//                            print("Appear:\(object.name)")
                        })
                        .onDisappear(perform: {
                            viewModel.setVisibility(of: object, isVisible: false)
                            viewModel.currentObject = object
//                            print("Disappear:\(object.name)")
                        })
                }
            }
            .frame(height: viewModel.height)
            .padding(EdgeInsets(top: 0, leading: viewModel.width/2.0, bottom: 0, trailing: viewModel.width/2.0))
            
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 10.0)
                .updating($isDetecting, body: { value, state, transaction in
                    print("Updating:\(value.translation.width)")
                })
                    .onChanged({ action in
                        print("Drag :\(action.translation.width) - \(action.predictedEndTranslation)")
                        //viewModel.setDragging(x: action.translation.width)
                        viewModel.yDraggingPosition = action.translation.width
                    })
                    .onEnded({ action in
                        print("Ended Long")
                    })
        )
            Text("\(isDetecting.width)")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
        } // VStack
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
