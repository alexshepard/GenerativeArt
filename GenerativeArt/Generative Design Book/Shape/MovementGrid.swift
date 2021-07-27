//
//  MovementGrid.swift
//  MovementGrid
//
//  Created by Alex Shepard on 7/26/21.
//

import SwiftUI

struct MovementGrid: View {
    public static let name = "Movement in a grid"
    public static let date = "25 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    @State private var tileCountX: CGFloat = 20

    var body: some View {
        Canvas { context, size in
            context.blendMode = .screen
            // square tiles
            let tileWidth = size.width / tileCountX
            let tileCountY = size.height / tileWidth

            for gridY in -1..<Int(tileCountY)+1 {
                for gridX in -1..<Int(tileCountX)+1 {
                    var innerContext = context
                    let x = size.width / tileCountX * CGFloat(gridX) + tileWidth / 2
                    let y = size.height / tileCountY * CGFloat(gridY) + tileWidth / 2
                    innerContext.translateBy(x: x, y: y)
                    
                    var lineWidth: CGFloat = 3
                    var scale: CGFloat = 1.0
                    
                    var jitter: CGPoint = .zero
                    if touchLocation != .zero {
                        lineWidth = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 1, maxDomain: 10).clamp(to: 1...10)
                        scale = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 0.5, maxDomain: 5.0).clamp(to: 0.5...5.0)
                        
                        let maxJitter = touchLocation.x / 20
                        jitter = CGPoint(x: CGFloat.random(in: -maxJitter...maxJitter),
                                         y: CGFloat.random(in: -maxJitter...maxJitter))

                    }
                    
                    innerContext.scaleBy(x: scale, y: scale)
                    
                    let rect = CGRect(x: -5 + jitter.x, y: -5 + jitter.y, width: tileWidth - 10, height: tileWidth - 10)
                    innerContext.stroke(Path(ellipseIn: rect), with: .color(.blue), lineWidth: lineWidth)
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

struct MovementGrid_Previews: PreviewProvider {
    static var previews: some View {
        MovementGrid()
    }
}
