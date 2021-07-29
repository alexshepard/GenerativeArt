//
//  ComplexModules.swift
//  ComplexModules
//
//  Created by Alex Shepard on 7/29/21.
//

import SwiftUI

struct ComplexModules: View, Sketch {
    public static let name = "Complex modules in a grid"
    public static let date = "29 July 2021"

    @State private var touchLocation: CGPoint = .zero
    @State private var seed: Int = 941
    
    private var blendModes = ["normal", "screen", "darken"]
    @State private var blendMode = 0
    
    var body: some View {
        VStack {
            Picker("Blend Mode", selection: $blendMode) {
                ForEach(0..<blendModes.count) {
                    Text(blendModes[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Canvas { context, size in
                
                if blendMode == 0 {
                    context.blendMode = .normal
                } else if blendMode == 1 {
                    context.blendMode = .screen
                } else {
                    context.blendMode = .darken
                }
                
                var rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
                
                let circleCount = touchLocation.x / 8 + 1
                let strideLength: CGFloat = 80
                
                let endSize = touchLocation.x.map(
                    minRange: 0,
                    maxRange: max(size.width, touchLocation.x),
                    minDomain: strideLength / 2,
                    maxDomain: 0)
                
                let endOffset = touchLocation.y.map(
                    minRange: 0,
                    maxRange: max(size.height, touchLocation.y),
                    minDomain: 0,
                    maxDomain: (strideLength - endSize) / 2
                )
                
                for gridY in stride(from: 0, to: Int(size.height), by: Int.Stride(strideLength)) {
                    for gridX in stride(from: 0, to: Int(size.width), by: Int.Stride(strideLength)) {
                        var innerContext = context
                        
                        innerContext.translateBy(x: CGFloat(gridX) + strideLength / 2, y: CGFloat(gridY) + strideLength / 2)
                                                
                        let toggle = Int.random(in: 0..<4, using: &rng)
                        var angle: Angle = .zero
                        if toggle == 0 { angle = Angle(radians: Double.pi * -0.5) }
                        if toggle == 1 { angle = Angle(radians: 0) }
                        if toggle == 2 { angle = Angle(radians: Double.pi * 0.5) }
                        if toggle == 3 { angle = Angle(radians: Double.pi) }
                        innerContext.rotate(by: angle)
                        
                        for i in 0..<Int(circleCount) {
                            let diameter = CGFloat(i).map(minRange: 0, maxRange: circleCount, minDomain: CGFloat(strideLength), maxDomain: endSize)
                            let xOffset = CGFloat(i).map(minRange: 0, maxRange: circleCount, minDomain: 0, maxDomain: endOffset)
                            
                            var rect = CGRect(x: -diameter / 2, y: -diameter / 2, width: diameter, height: diameter)
                            rect = rect.offsetBy(dx: xOffset, dy: 0)
                            innerContext.stroke(Path(ellipseIn: rect), with: .color(.blue.opacity(0.5)))
                        }
                    }
                }
            }
            .background(Color.yellow)
            .onTapGesture {
                seed  = Int.random(in: 0...10000)
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                                        self.touchLocation = newValue.location
                                    })
            )
        }
    }
}

struct ComplexModules_Previews: PreviewProvider {
    static var previews: some View {
        ComplexModules()
    }
}
