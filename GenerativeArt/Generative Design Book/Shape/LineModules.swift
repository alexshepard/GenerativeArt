//
//  LineModules.swift
//  LineModules
//
//  Created by Alex Shepard on 7/31/21.
//

import SwiftUI

extension Path {
    init(lineModuleIn rect: CGRect) {
        self.init()
        let x1 = rect.midX
        let y1 = rect.midY
        let pt1 = CGPoint(x: x1, y: y1)
        
        for side in 0..<4 {
            self.move(to: pt1)
            var x2: CGFloat = .zero
            var y2: CGFloat = .zero
            
            for i in 0...10 {
                if side == 0 {
                    x2 = rect.minX + (rect.size.width / CGFloat(10)) * CGFloat(i)
                    y2 = rect.minY
                } else if side == 1 {
                    x2 = rect.minX
                    y2 = rect.maxY - (rect.size.height / CGFloat(10)) * CGFloat(i)
                } else if side == 2 {
                    x2 = rect.maxX
                    y2 = rect.maxY - (rect.size.height / CGFloat(10)) * CGFloat(i)
                } else if side == 3 {
                    x2 = rect.minX + (rect.size.width / CGFloat(10)) * CGFloat(i)
                    y2 = rect.maxY
                }
                let pt2 = CGPoint(x: x2, y: y2)
                self.move(to: pt1)
                self.addLine(to: pt2)

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
                
                var xStrideLength: CGFloat = 50
                var yStrideLength: CGFloat = 50
                let minStrideLength: CGFloat = 25

                if touchLocation != .zero {
                    xStrideLength = touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: minStrideLength, maxDomain: size.width)
                    yStrideLength = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: minStrideLength, maxDomain: size.height)
                }
                
                for gridY in stride(from: 0, to: size.height, by: yStrideLength) {
                    for gridX in stride(from: 0, to: size.width, by: xStrideLength) {
                        let rect = CGRect(x: gridX, y: gridY, width: xStrideLength, height: yStrideLength)
                        context.stroke(Path(lineModuleIn: rect), with: .color(.black), lineWidth: 1)
                        
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

struct LineModules_Previews: PreviewProvider {
    static var previews: some View {
        LineModules()
    }
}
