//
//  DarkeningCircles.swift
//  DarkeningCircles
//
//  Created by Alex Shepard on 8/6/21.
//

import SwiftUI

struct DarkeningCircles: View, Sketch {
    public static var name = "Darkening Circles"
    public static var date = "6 August 2021"
    
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
                
                let strideLength: CGFloat = 80
                
                let stepSize = touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: 1, maxDomain: strideLength)
                let endSize = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 1, maxDomain: strideLength)
                
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
                        
                        
                        
                        for i in 0..<Int(stepSize) {
                            let diameter = CGFloat(i)
                                .map(minRange: 0, maxRange: stepSize, minDomain: strideLength, maxDomain: endSize)
                            
                            let alpha = CGFloat(i) / CGFloat(stepSize)
                            let r = CGFloat(0.592).lerp(to: 0.157, alpha: alpha)
                            let g = CGFloat(0.624).lerp(to: 0.149, alpha: alpha)
                            let b = CGFloat(0.69).lerp(to: 0.078, alpha: alpha)
                            let lerpColor = Color(red: r, green: g, blue: b)
                            
                            let rect = CGRect(x: (diameter / -2) + CGFloat(i), y: -diameter / 2, width: diameter, height: diameter)
                            innerContext.fill(Path(ellipseIn: rect), with: .color(lerpColor))
                        }
                    }
                }
            }

            .background(Color(red: 0.592, green: 0.624, blue: 0.69))
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

struct DarkeningCircles_Previews: PreviewProvider {
    static var previews: some View {
        DarkeningCircles()
    }
}
