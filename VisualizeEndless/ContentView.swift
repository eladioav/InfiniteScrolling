//
//  ContentView.swift
//  VisualizeEndless
//
//  Created by Eladio Alvarez Valle on 17/08/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel<ImageObject>()
    
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
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        .gesture(dragGesture)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
