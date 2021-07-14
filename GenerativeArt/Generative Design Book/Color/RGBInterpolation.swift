//
//  RGBInterpolation.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/13/21.
//

import SwiftUI

struct RGBInterpolation: View {
    public static let name = "Color palettes through RGB interpolation"
    public static let date = "13 July 2021"
    
    @State private var tileCountX = 50
    @State private var tileCountY = 5
    
    @State private var leftReds = [Double]()
    @State private var rightReds = [Double]()
    
    @State private var leftGreens = [Double]()
    @State private var rightGreens = [Double]()

    @State private var leftBlues = [Double]()
    @State private var rightBlues = [Double]()
    
    func shakeColors() {
        leftReds.removeAll()
        rightReds.removeAll()
        leftGreens.removeAll()
        rightGreens.removeAll()
        leftBlues.removeAll()
        rightBlues.removeAll()

        for _ in 0...10 {
            leftReds.append(Double.random(in: 0...1.0))
            rightReds.append(Double.random(in: 0...1.0))
            leftGreens.append(Double.random(in: 0...1.0))
            rightGreens.append(Double.random(in: 0...1.0))
            leftBlues.append(Double.random(in: 0...1.0))
            rightBlues.append(Double.random(in: 0...1.0))
        }
    }
    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    // .onAppear() will setup colors but Canvas draws first
                    if leftReds.count == 0 { return }
                    
                    let tileWidth = geom.size.width / CGFloat(tileCountX)
                    let tileHeight = geom.size.height / CGFloat(tileCountY)
                    
                    for y in 0..<tileCountY {
                        let leftRed: CGFloat = leftReds[y]
                        let rightRed: CGFloat = rightReds[y]
                        
                        let leftGreen: CGFloat = leftGreens[y]
                        let rightGreen: CGFloat = rightGreens[y]

                        let leftBlue: CGFloat = leftBlues[y]
                        let rightBlue: CGFloat = rightBlues[y]
                        
                        for x in 0..<tileCountX {
                            let alpha: CGFloat = CGFloat(x).map(minRange: 0, maxRange: CGFloat(tileCountX - 1), minDomain: 0, maxDomain: 1)
                            
                            // lerp the color with HSB
                            let lerpRed = leftRed.lerp(to: rightRed, alpha: alpha)
                            let lerpGreen = leftGreen.lerp(to: rightGreen, alpha: alpha)
                            let lerpBlue = leftBlue.lerp(to: rightBlue, alpha: alpha)
                            let lerpColor = Color(red: lerpRed, green: lerpGreen, blue: lerpBlue)
                            
                            let rect = CGRect(x: tileWidth * CGFloat(x), y: tileHeight * CGFloat(y), width: tileWidth, height: tileHeight)
                            context.stroke(Path(rect), with: .color(lerpColor))
                            context.fill(Path(rect), with: .color(lerpColor))
                        }
                    }
                }
                .onAppear {
                    shakeColors()
                }
                
                .frame(width: geom.size.width, height: geom.size.height)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ newValue in
                                // map and clamp
                                self.tileCountX = Int(newValue.location.x.map(
                                    minRange: 0,
                                    maxRange: geom.size.width,
                                    minDomain: 2,
                                    maxDomain: 100
                                ).clamp(to: 2...100))
                                self.tileCountY = Int(newValue.location.y.map(
                                    minRange: 0,
                                    maxRange: geom.size.height,
                                    minDomain: 2,
                                    maxDomain: 10
                                ).clamp(to: 2...10))
                            })
                )
            }
        }
        .navigationBarTitle(Self.name)
        .navigationBarItems(trailing: Button(action: {
            self.shakeColors()
        }, label: {
            Image(systemName: "return")
        }))
    }
}

struct RGBInterpolation_Previews: PreviewProvider {
    static var previews: some View {
        RGBInterpolation()
    }
}
