//
//  ContentView.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel<ImageObject>()
    @State var globalWidth: CGFloat = 0.0
    
    var dragGesture: some Gesture  {
        return DragGesture()
            .onEnded({ action in
                        viewModel.yDraggingPosition = action.translation.width }
            )
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: viewModel.width/8.0) {
                ForEach(viewModel.data, id:\.self) { object in
                    Image(systemName: object.content.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: viewModel.width ,height: viewModel.height)
                }
            }
            
            Color.white.opacity(0.01)
                .gesture(dragGesture)
            
        } //ZStack
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
    }
    
    /*
    var body: some View {
        VStack {
            GeometryReader { grGlobal in
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { sp in
                        HStack(spacing: viewModel.width/8.0) {
                            ForEach(viewModel.data, id:\.self) { object in
                                Image(systemName: object.content.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: viewModel.width)
                                    .onAppear(perform: {
                                        print("Appear:\(object.content.name)")
                                        object.isVisible = true
                                    })
                                    .onDisappear(perform: {
                                        print("Disappear:\(object.content.name)")
                                        object.isVisible = false
                                    })
                            }
                        }
//                            .frame(height: viewModel.height)
                        .onReceive(viewModel.$nextObject, perform: { object in
                            guard let object = object else { return }
                            print("Scroll:\(object.content.name)")
                            sp.scrollTo(object)
                        })
                    }//ScrollView reader
//                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
//                    .frame(width: globalWidth,height: viewModel.height, alignment: .center)
//                    .frame(height: viewModel.height)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }// ScrollView
        
                Color.white.opacity(0.01)
                    .gesture(
                        DragGesture()
                            .onEnded({ action in viewModel.yDraggingPosition = action.translation.width })
                    )
            } //ZStack
            .frame(width: globalWidth, alignment: .center)
            .onAppear(perform: {
                let rectScreen = grGlobal.frame(in: .global)
                globalWidth = rectScreen.width
                print("OnAppear Z - W:\(rectScreen.width) - H:\(rectScreen.height)")
            })
            } // Geometry Reader
        } // VStack
    }
    */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
