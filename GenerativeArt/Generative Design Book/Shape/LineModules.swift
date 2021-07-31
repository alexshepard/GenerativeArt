//
//  LineModules.swift
//  LineModules
//
//  Created by Alex Shepard on 7/31/21.
//

import SwiftUI

extension Path {
    init(radiatingLinesIn rect: CGRect, lineCountPerSide: Int = 10) {
        assert(lineCountPerSide >= 1, "line count per side must be at least 1")
        
        self.init()
        let origin = CGPoint(x: rect.midX, y: rect.midY)
        
        for side in 0..<4 {
            var x2: CGFloat = .zero
            var y2: CGFloat = .zero
            
            for i in 0..<lineCountPerSide {
                if side == 0 {
                    // top side - left to right
                    x2 = rect.minX + (rect.size.width / CGFloat(lineCountPerSide)) * CGFloat(i)
                    y2 = rect.minY
                } else if side == 1 {
                    // left side, bottom to top
                    x2 = rect.minX
                    y2 = rect.maxY - (rect.size.height / CGFloat(lineCountPerSide)) * CGFloat(i)
                } else if side == 2 {
                    // right side, top to bottom
                    x2 = rect.maxX
                    y2 = rect.minY + (rect.size.height / CGFloat(lineCountPerSide)) * CGFloat(i)
                } else if side == 3 {
                    // bottom side, right to left
                    x2 = rect.maxX - (rect.size.width / CGFloat(lineCountPerSide)) * CGFloat(i)
                    y2 = rect.maxY
                }
                let end = CGPoint(x: x2, y: y2)
                move(to: origin)
                addLine(to: end)
            }
        }
    }
}

struct LineModules: View, Sketch {
    public static var name = "Line Modules"
    public static var date = "31 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            Canvas { context, size in
                context.blendMode = .screen
                
                var xStrideLength: CGFloat = 200
                var yStrideLength: CGFloat = 200
                let minStrideLength: CGFloat = 25

                if touchLocation != .zero {
                    xStrideLength = touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: minStrideLength, maxDomain: size.width)
                    yStrideLength = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: minStrideLength, maxDomain: size.height)
                }
                
                for gridY in stride(from: 0, to: size.height, by: yStrideLength) {
                    for gridX in stride(from: 0, to: size.width, by: xStrideLength) {
                        let rect = CGRect(x: gridX, y: gridY, width: xStrideLength, height: yStrideLength)
                        context.stroke(Path(radiatingLinesIn: rect, lineCountPerSide: 3), with: .color(.green.opacity(0.2)), lineWidth: 1)
                        
                    }
                }
            }
            .background(Color.orange)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                                        self.touchLocation = newValue.location
                                    })
            )
        }
    }
}

struct LineModules_Previews: PreviewProvider {
    static var previews: some View {
        LineModules()
    }
}
