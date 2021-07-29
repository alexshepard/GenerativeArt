//
//  RadGrid.swift
//  RadGrid
//
//  Created by Alex Shepard on 7/27/21.
//

import SwiftUI

struct RadGrid: View, Sketch {
    public static let name = "Rad grid"
    public static let date = "27 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    private var maxDistance: CGFloat = 500
    
    @State private var strideBy: CGFloat = 25
    
    var body: some View {
        VStack {
            Slider(value: $strideBy, in: 5...50)
                .padding()
            Canvas { context, size in
                context.blendMode = .screen

                for gridY in stride(from: -100, to: size.height + 100, by: strideBy) {
                    for gridX in stride(from: -100, to: size.width + 100, by: strideBy) {
                        let xDist = gridX.distance(to: touchLocation.x)
                        let yDist = gridY.distance(to: touchLocation.y)
                        let distance = sqrt(xDist * xDist + yDist * yDist)
                        
                        let diameter = distance / maxDistance * 40
                        
                        var innerContext = context
                        innerContext.translateBy(x: gridX, y: gridY)
                        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
                        innerContext.stroke(Path(rect), with: .color(.black), lineWidth: 10)
                    }
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                                        self.touchLocation = newValue.location
                                    })
            )
        }
    }
}

struct RadGrid_Previews: PreviewProvider {
    static var previews: some View {
        RadGrid()
    }
}
