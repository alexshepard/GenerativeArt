//
//  ColorPaletteInterpolation.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/12/21.
//

import SwiftUI

struct ColorPaletteInterpolation: View, Sketch {
    public static let name = "Color palettes through interpolation"
    public static let date = "12 July 2021"
    
    @State private var tileCountX = 50
    @State private var tileCountY = 5
    
    @State private var leftHues = [Double]()
    @State private var rightHues = [Double]()
    
    @State private var leftSats = [Double]()
    let rightS: CGFloat = 1.0

    let leftB: CGFloat = 1.0
    @State private var rightBs = [Double]()
    

    func shakeColors() {
        leftHues.removeAll()
        rightHues.removeAll()
        leftSats.removeAll()
        rightBs.removeAll()
        
        for _ in 0...10 {
            leftHues.append(Double.random(in: 0..<0.167))
            rightHues.append(Double.random(in: 0.444..<0.5278))
            leftSats.append(Double.random(in: 0...1.0))
            rightBs.append(Double.random(in: 0...1.0))
        }
    }
    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    // .onAppear() will setup colors but Canvas draws first
                    if leftHues.count == 0 { return }
                    
                    let tileWidth = geom.size.width / CGFloat(tileCountX)
                    let tileHeight = geom.size.height / CGFloat(tileCountY)
                    
                    for y in 0..<tileCountY {
                        let leftH: CGFloat = leftHues[y]
                        let rightH: CGFloat = rightHues[y]
                        
                        let leftS: CGFloat = leftSats[y]
                        let rightB: CGFloat = rightBs[y]
                        
                        for x in 0..<tileCountX {
                            let alpha: CGFloat = CGFloat(x).map(minRange: 0, maxRange: CGFloat(tileCountX - 1), minDomain: 0, maxDomain: 1)
                            
                            // lerp the color with HSB
                            let lerpH = leftH.lerp(to: rightH, alpha: alpha)
                            let lerpS = leftS.lerp(to: rightS, alpha: alpha)
                            let lerpB = leftB.lerp(to: rightB, alpha: alpha)
                            let lerpColor = Color(hue: lerpH, saturation: lerpS, brightness: lerpB)
                            
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

struct ColorPaletteInterpolation_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteInterpolation()
    }
}
