//
//  PerlinAcrossShapes.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI
import GameplayKit

struct PerlinAcrossShapes: View {
    public static let name = "Perlin Across Shapes"
    public static let date = "5 July 2021"
    
    let timer = Timer.publish(every: 1/10, on: .main, in: .common).autoconnect()
        
    @State private var cPaths = [Path]()
    @State private var c2Paths = [Path]()
    
    @State private var c: Color = Color.white
    @State private var c2: Color = Color.black

    let noise: GKNoise
    let noiseStepSize = 0.01
    
    init() {
        let source: GKPerlinNoiseSource = GKPerlinNoiseSource(frequency: 10.0, octaveCount: 4, persistence: 0.5, lacunarity: 2.145, seed: 2)
        self.noise = GKNoise(source)
        setupColors()
    }
    
    func setupColors() {
        let r = Double.random(in: 0..<1)
        let g = Double.random(in: 0..<1)
        let b = Double.random(in: 0..<1)
        let o = Double.random(in: 0..<1)
        
        self.c = Color(.sRGB, red: r, green: g, blue: b, opacity: o)
        self.c2 = Color(.sRGB, red: 1-r, green: 1-g, blue: 1-b, opacity: o)
    }
    
    @State private var noiseX = Double.random(in: 0...40000)
    @State private var noiseY = Double.random(in: 0...40000)
    
    @State private var noiseX2 = Double.random(in: 0...40000)
    @State private var noiseY2 = Double.random(in: 0...40000)

    @State private var noiseX3 = Double.random(in: 0...40000)
    @State private var noiseY3 = Double.random(in: 0...40000)
    
    @State private var noiseX4 = Double.random(in: 0...40000)
    @State private var noiseY4 = Double.random(in: 0...40000)

    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    for i in 0..<cPaths.count {
                        context.fill(cPaths[i], with: .color(c))
                        context.fill(c2Paths[i], with: .color(c2))
                        
                        let trailsRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                        let trailsColor = Color.init(.sRGB, white: 1.0, opacity: 0.1)
                        context.fill(Path.init(trailsRect), with: .color(trailsColor))
                    }
                }
                .background(Color.white)
                .navigationBarItems(trailing: Button {
                    self.setupColors()
                } label: {
                    Image.init(systemName: "return")
                })
                .onReceive(timer) { _ in
                    
                    let x1 = map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: Float(geom.size.width)-20, value: floatFromNoise(seedX: noiseX, seedY: noiseY))
                    noiseX += noiseStepSize
                    noiseY += noiseStepSize
                    
                    let y1 = map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: Float(geom.size.width)-20, value: floatFromNoise(seedX: noiseX2, seedY: noiseY2))
                    noiseX2 += noiseStepSize
                    noiseY2 += noiseStepSize
                    
                    let x2 = map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: Float(geom.size.width)-20, value: floatFromNoise(seedX: noiseX3, seedY: noiseX3))
                    noiseX3 += noiseStepSize
                    noiseY3 += noiseStepSize

                    let y2 = map(minRange: -1, maxRange: 1, minDomain: 10, maxDomain: Float(geom.size.width)-20, value: floatFromNoise(seedX: noiseX4, seedY: noiseY4))
                    noiseX4 += noiseStepSize
                    noiseY4 += noiseStepSize
                    
                    
                    let path = Path { path in
                        path.move(to: CGPoint(x: 10, y: 10))
                        path.addLine(to: CGPoint(x: CGFloat(x1), y: CGFloat(y1)))
                        path.addLine(to: CGPoint(x: CGFloat(x2), y: CGFloat(y2)))
                        path.addLine(to: CGPoint(x: 10, y: 10))
                    }
                    cPaths.append(path)
                    if cPaths.count > 90 {
                        cPaths.remove(at: 0)
                    }
                    
                    let path2 = Path { path in
                        path.move(to: CGPoint(x: geom.size.width - 10, y: geom.size.height - 10))
                        path.addLine(to: CGPoint(x: CGFloat(x1), y: CGFloat(y1)))
                        path.addLine(to: CGPoint(x: CGFloat(x2), y: CGFloat(y2)))
                        path.addLine(to: CGPoint(x: geom.size.width - 10, y: geom.size.height - 10))
                    }
                    c2Paths.append(path2)
                    if c2Paths.count > 90 {
                        c2Paths.remove(at: 0)
                    }
                    
                }
            } else {
                Text("ios 14 fallback view")
            }
        }
    }
    
    func floatFromNoise(seedX: Double, seedY: Double) -> Float {
        let v = vector_float2(x: Float(seedX), y: Float(seedY))
        return noise.value(atPosition: v)
    }
    
    func map(minRange:Float, maxRange:Float, minDomain:Float, maxDomain:Float, value:Float) -> Float {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
    
    func makeNoiseMap(columns: Int, rows: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.9

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
}

struct PerlinAcrossShapes_Previews: PreviewProvider {
    static var previews: some View {
        PerlinAcrossShapes()
    }
}
