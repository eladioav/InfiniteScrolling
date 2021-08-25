//
//  ContentView.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @GestureState var isDetecting = CGSize.zero {
        didSet {
            print("Updating Gesture")
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { sp in
                    LazyHStack(spacing: viewModel.width/2) {
                        ForEach(viewModel.data, id:\.name) { object in
                            Image(systemName: object.name)
                                .resizable()
                                .scaledToFit()
                                .frame(height: viewModel.height)
                                .onAppear(perform: {
                                    viewModel.currentObjectState = (object, true)
                                })
                                .onDisappear(perform: {
                                    viewModel.currentObjectState = (object, false)
                                })
                        }
                    }
                    .frame(height: viewModel.height)
                    .padding(EdgeInsets(top: 0, leading: viewModel.width/2.0, bottom: 0, trailing: viewModel.width/2.0))
                    .onReceive(viewModel.$nextObject, perform: { object in
                        print("On Receive:\(object)")
                        sp.scrollTo(object)
                    })
                        
                    }//ScrollView reader
                }// ScrollView
                .background(Color.red)
        
                Color.white.opacity(0.01)
                    .gesture(
                        DragGesture()
                            .updating($isDetecting, body: { value, state, transaction in
                                print("Updating:\(value.translation.width)")
                            })
                                .onChanged({ action in
                                    print("Drag :\(action.translation.width) - \(action.predictedEndTranslation)")
                                })
                                .onEnded({ action in
                                    print("Ended Long")
                                    viewModel.yDraggingPosition = action.translation.width
                                })
                    )
                
            } //ZStack
        
            Text("\(viewModel.yDraggingPosition) -\(viewModel.topIsVisible.description)")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
        } // VStack
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
