//
//  JitterQuads.swift
//  JitterQuads
//
//  Created by Alex Shepard on 7/28/21.
//

import SwiftUI

struct JitterQuad: Shape {
    let p1Jitter: CGPoint
    let p2Jitter: CGPoint
    let p3Jitter: CGPoint
    let p4Jitter: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + p1Jitter.x, y: rect.minY + p1Jitter.y))
        path.addLine(to: CGPoint(x: rect.maxX + p2Jitter.x, y: rect.minY + p2Jitter.y))
        path.addLine(to: CGPoint(x: rect.maxX + p3Jitter.x, y: rect.maxY + p3Jitter.y))
        path.addLine(to: CGPoint(x: rect.minX + p4Jitter.x, y: rect.maxY + p4Jitter.y))
        path.addLine(to: CGPoint(x: rect.minX + p1Jitter.x, y: rect.minY + p1Jitter.y))
        return path
    }
}

struct JitterQuads: View {
    public static let name = "Jitter Quads"
    public static let date = "28 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    @State private var seed: Int = 941
    
    private var strides = ["10", "25", "50"]
    @State private var strideVal = 1
    
    var body: some View {
        
        VStack {
            Picker("stride", selection: $strideVal) {
                ForEach(0..<strides.count) {
                    Text(strides[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Canvas { context, size in
                context.blendMode = .screen
                
                var rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
                
                
                var strideLength: CGFloat = 3
                if let x = Double(strides[strideVal]) {
                    strideLength = CGFloat(x)
                }
                
                let xScale = touchLocation.x / 20
                let yScale = touchLocation.y / 20
                
                for gridY in stride(from: -100, to: size.height + 100, by: strideLength) {
                    for gridX in stride(from: -100, to: size.width + 100, by: strideLength) {
                        var innerContext = context
                        innerContext.translateBy(x: gridX, y: gridY)
                        var scale = Double.random(in: 0.8...1.2, using: &rng)
                        innerContext.scaleBy(x: scale, y: scale)
                        let fillColor = Color(hue: Double.random(in: 0.5...0.55, using: &rng),
                                              saturation: Double.random(in: 0.8...1.0, using: &rng),
                                              brightness: Double.random(in: 0.54...0.74, using: &rng))
                            .opacity(0.6)
                        
                        let rect = CGRect(x: -strideLength/2, y: -strideLength/2, width: strideLength, height: strideLength)
                        let quad = JitterQuad(
                            p1Jitter: CGPoint(
                                x: CGFloat.random(in: -1...1, using: &rng) * xScale,
                                y: CGFloat.random(in: -1...1, using: &rng) * yScale
                            ),
                            p2Jitter: CGPoint(
                                x: CGFloat.random(in: -1...1, using: &rng) * xScale,
                                y: CGFloat.random(in: -1...1, using: &rng) * yScale
                            ),
                            p3Jitter: CGPoint(
                                x: CGFloat.random(in: -1...1, using: &rng) * xScale,
                                y: CGFloat.random(in: -1...1, using: &rng) * yScale
                            ),
                            p4Jitter: CGPoint(
                                x: CGFloat.random(in: -1...1, using: &rng) * xScale,
                                y: CGFloat.random(in: -1...1, using: &rng) * yScale
                            )
                        )
                        innerContext.fill(quad.path(in: rect), with: .color(fillColor))
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

struct JitterQuads_Previews: PreviewProvider {
    static var previews: some View {
        JitterQuads()
    }
}
