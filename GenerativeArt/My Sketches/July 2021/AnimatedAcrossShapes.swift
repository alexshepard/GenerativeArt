//
//  AnimatedAcrossShapes.swift
//  AnimatedAcrossShapes
//
//  Created by Alex Shepard on 7/18/21.
//

import SwiftUI
import GameKit

struct MyTriangle: Shape {
    var cornerAnchor: NSRectAlignment
    
    var centerX: CGFloat
    var centerY: CGFloat
    
    var centerX2: CGFloat
    var centerY2: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if cornerAnchor == .topLeading {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        path.addLine(to: CGPoint(x: centerX, y: centerY))
        path.addLine(to: CGPoint(x: centerX2, y: centerY2))
        
        if cornerAnchor == .topLeading {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        return path
    }

}

extension MyTriangle: Animatable {
    public var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>> {
        get {
            AnimatablePair(centerX, AnimatablePair(centerY, AnimatablePair(centerX2, centerY2)))
        }
        set {
            self.centerX = CGFloat(newValue.first)
            self.centerY = CGFloat(newValue.second.first)
            
            self.centerX2 = CGFloat(newValue.second.second.first)
            self.centerY2 = CGFloat(newValue.second.second.second)
        }
    }
}

struct AnimatedAcrossShapes: View, Sketch {
    public static let name = "Animated Across Shapes"
    public static let date = "18 July 2021"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let noise: GKNoise
    private let noiseStepSize = 0.001
    
    @State private var noiseA = Double.random(in: 0...40000)
    @State private var noiseB = Double.random(in: 0...40000)
    @State private var noiseC = Double.random(in: 0...40000)
    @State private var noiseD = Double.random(in: 0...40000)

    
    init() {
        let source: GKPerlinNoiseSource = GKPerlinNoiseSource(frequency: 10.0, octaveCount: 4, persistence: 0.5, lacunarity: 2.145, seed: 2)
        self.noise = GKNoise(source)
    }
    
    func floatFromNoise(seedX: Double, seedY: Double) -> CGFloat {
        let v = vector_float2(x: Float(seedX), y: Float(seedY))
        return CGFloat(noise.value(atPosition: v))
    }
    
    @State private var centerX: CGFloat = 200
    @State private var centerY: CGFloat = 200
    
    @State private var centerX2: CGFloat = 250
    @State private var centerY2: CGFloat = 250

    @State private var color: Color = .blue
    @State private var opposite: Color = .red
    
    private var stepSources = ["random", "perlin"]
    @State private var stepSource = 0
    
    
    private var perlinStepSizes = [0.001, 0.01, 0.1, 1.0]
    @State private var perlinStepSize = 1
    
    var body: some View {
        VStack {
            Picker("step source", selection: $stepSource) {
                ForEach(0..<stepSources.count) { source in
                    Text(stepSources[source])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if stepSource == 1 {
                HStack {
                    Text("Step Size")
                    Picker("step size", selection: $perlinStepSize) {
                        ForEach(0..<perlinStepSizes.count) { size in
                            Text("\(perlinStepSizes[size], specifier: "%g")")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                    
            }
                        
            GeometryReader { geom in
                ZStack {
                    MyTriangle(cornerAnchor: .topLeading, centerX: centerX, centerY: centerY, centerX2: centerX2, centerY2: centerY2)
                        .foregroundColor(color)
                        .padding()
                    MyTriangle(cornerAnchor: .bottomTrailing, centerX: centerX, centerY: centerY, centerX2: centerX2, centerY2: centerY2)
                        .foregroundColor(opposite)
                        .padding()
                    
                }
                .onReceive(timer) { _ in
                    withAnimation(.linear(duration: 1)) {
                        if self.stepSource == 0 {
                            centerX = CGFloat.random(in: 10...geom.size.width - 20)
                            centerY = CGFloat.random(in: 10...geom.size.height - 20)
                            
                            centerX2 = CGFloat.random(in: 10...geom.size.width - 20)
                            centerY2 = CGFloat.random(in: 10...geom.size.height - 20)
                        } else {
                            
                            let x1 = floatFromNoise(seedX: noiseA, seedY: noiseB)
                            centerX = x1.map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: geom.size.width - 20)
                            let y1 = floatFromNoise(seedX: noiseB, seedY: noiseA)
                            centerY = y1.map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: geom.size.height - 20)
                            
                            let x2 = floatFromNoise(seedX: noiseC, seedY: noiseD)
                            centerX2 = x2.map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: geom.size.width - 20)
                            let y2 = floatFromNoise(seedX: noiseD, seedY: noiseC)
                            centerY2 = y2.map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: geom.size.height - 20)
                            
                            noiseA += perlinStepSizes[perlinStepSize]
                            noiseB += perlinStepSizes[perlinStepSize]
                            noiseC += perlinStepSizes[perlinStepSize]
                            noiseD += perlinStepSizes[perlinStepSize]
                        }
                    }
                }
                .onTapGesture {
                    let hue = Double.random(in: 0..<1)
                    self.color = Color(hue: hue, saturation: 1, brightness: 1).opacity(0.8)
                    self.opposite = Color(hue: 1-hue, saturation: 1, brightness: 1).opacity(0.8)
                }
            }
        }
    }
}


struct AnimatedAcrossShapes_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedAcrossShapes()
    }
}
