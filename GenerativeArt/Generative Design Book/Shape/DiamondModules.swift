//
//  DiamondModules.swift
//  DiamondModules
//
//  Created by Alex Shepard on 7/31/21.
//

import SwiftUI

extension Path {
    init(diamondIn rect: CGRect, originOffset: CGFloat = 0, lineCountPerSide: Int = 10) {
        self.init()
        
        let leftOrigin = CGPoint(x: rect.minX, y: rect.minY + originOffset)
        for i in 0..<lineCountPerSide {
            let x = rect.maxX
            let y = rect.minY + (rect.size.height / CGFloat(lineCountPerSide)) * CGFloat(i)
            
            move(to: leftOrigin)
            addLine(to: CGPoint(x: x, y: y))
        }
        
        let rightOrigin = CGPoint(x: rect.maxX, y: rect.maxY - originOffset)
        for i in 0..<lineCountPerSide {
            let x = rect.minX
            let y = rect.minY + (rect.size.height / CGFloat(lineCountPerSide)) * CGFloat(i)
            
            move(to: rightOrigin)
            addLine(to: CGPoint(x: x, y: y))
        }

    }
    /*
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
     */
}

struct DiamondModules: View, Sketch {
    public static var name = "Diamond Modules"
    public static var date = "31 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    
    @State private var seed: Int = 941
    
    var body: some View {
        VStack {
            Canvas { context, size in
                context.blendMode = .normal
                context.fill(Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)), with: .color(.orange))
                
                var rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
                
                let strideLength: CGFloat = 100
                
                let offset = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 0, maxDomain: 100).clamp(to: 0...100)
                let numLines = Int(touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: 4, maxDomain: 40))
                
                for gridY in stride(from: 0, to: size.height, by: strideLength) {
                    for gridX in stride(from: 0, to: size.width, by: strideLength) {
                        let color = Color(
                            hue: Double.random(in: 0.55...0.65, using: &rng),
                            saturation: Double.random(in: 0.8...1.0, using: &rng),
                            brightness: Double.random(in: 0.5...0.8, using: &rng)
                        )
                            .opacity(0.7)
                        let rect = CGRect(x: gridX, y: gridY, width: strideLength, height: strideLength)
                        context.stroke(Path(diamondIn: rect, originOffset: offset, lineCountPerSide: numLines), with: .color(color))
                    }
                }
            }
            .onTapGesture {
                self.seed = Int.random(in: 0...10000)
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                                        self.touchLocation = newValue.location
                                    })
            )
        }
    }
}

struct DiamondModules_Previews: PreviewProvider {
    static var previews: some View {
        DiamondModules()
    }
}
