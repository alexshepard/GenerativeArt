//
//  CorridorModules.swift
//  CorridorModules
//
//  Created by Alex Shepard on 8/1/21.
//

import SwiftUI

extension Path {
    init(corridorIn rect: CGRect, originOffset: CGFloat, lineCountPerSide: Int = 10, centered: Bool = false) {
        assert(lineCountPerSide >= 1, "line count per side must be at least 1")
        assert(originOffset >= 0.0, "origin offset must be positive")
        
        self.init()
        let originX = centered ? rect.midX : rect.origin.x + originOffset
        let originY = rect.origin.y + originOffset
        let origin = CGPoint(x: originX, y: originY)
        
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

struct CorridorModules: View, Sketch {
    public static var name = "Corridor Modules"
    public static var date = "1 August 2021"

    @State private var touchLocation: CGPoint = .zero
    @State private var centeredCorridoor = false
    @State private var staggered = false
    
    var body: some View {
        VStack {
            Toggle("Centered", isOn: $centeredCorridoor)
                .padding([.leading, .trailing])
            Toggle("Staggered", isOn: $staggered)
                .padding([.leading, .trailing, .bottom])

            Canvas { context, size in
                context.blendMode = .normal
                                
                let strideLength: CGFloat = 100
                
                let offset = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 0, maxDomain: strideLength/2).clamp(to: 0...(strideLength/2))
                let numLines = Int(touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: 4, maxDomain: 40))
                
                var counter = 1
                for gridY in stride(from: 0, to: size.height, by: strideLength) {
                    let xorigin = staggered ? (counter.isMultiple(of: 2) ? 0 : -strideLength / 2) : 0
                    let xend = staggered ? (counter.isMultiple(of: 2) ? size.width : size.width + strideLength / 2) : size.width
                    for gridX in stride(from: xorigin, to: xend, by: strideLength) {
                        let rect = CGRect(x: gridX, y: gridY, width: strideLength, height: strideLength)
                        context.stroke(Path(corridorIn: rect, originOffset: offset, lineCountPerSide: numLines, centered: centeredCorridoor), with: .color(.black))
                    }
                    counter += 1
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

struct CorridorModules_Previews: PreviewProvider {
    static var previews: some View {
        CorridorModules()
    }
}
