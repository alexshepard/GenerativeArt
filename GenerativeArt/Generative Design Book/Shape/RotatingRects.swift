//
//  RotatingRects.swift
//  RotatingRects
//
//  Created by Alex Shepard on 8/8/21.
//

import SwiftUI

struct RotatingRects: View, Sketch {
    public static var name = "Rotating Rects"
    public static var date = "8 August 2021"
    
    @State private var touchLocation: CGPoint = .zero
    
    private var colorModes = ["black and white", "red", "blue"]
    @State private var colorMode = 0
    
    var body: some View {
        VStack {
            Picker("color", selection: $colorMode) {
                ForEach(0..<colorModes.count) { Text(colorModes[$0]) }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Canvas { context, size in
                context.blendMode = .screen
                let strideLength: CGFloat = 390/4
                let rects = touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: 20, maxDomain: 100)
                let rotate = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 0, maxDomain: 30)
                
                for gridY in stride(from: 0, to: Int(size.height), by: Int.Stride(strideLength)) {
                    for gridX in stride(from: 0, to: Int(size.width), by: Int.Stride(strideLength)) {
                        
                        var innerContext = context
                        
                        innerContext.translateBy(x: CGFloat(gridX) + strideLength / 2, y: CGFloat(gridY) + strideLength / 2)
                        
                        let rect = CGRect(x: -strideLength / 2, y: -strideLength / 2, width: strideLength, height: strideLength)
                        for i in 1..<Int(rects) {
                            var innerInner = innerContext
                            
                            let inset = (strideLength / rects) * CGFloat(i)
                            let innerRect = rect.insetBy(dx: inset, dy: inset)
                            
                            innerInner.rotate(by: .degrees(Double(i) * rotate))
                            
                            if colorMode == 0 {
                                innerInner.stroke(Path(innerRect), with: .color(.black), lineWidth: 0.5)
                            } else if colorMode == 1 {
                                let endR: CGFloat = 166/255
                                let endG: CGFloat = 141/255
                                let endB: CGFloat = 5 / 255
                                let alpha = CGFloat(i) / rects
                                
                                let lerpR = CGFloat(0).lerp(to: endR, alpha: alpha)
                                let lerpG = CGFloat(0).lerp(to: endG, alpha: alpha)
                                let lerpB = CGFloat(0).lerp(to: endB, alpha: alpha)
                                let color = Color(red: lerpR, green: lerpG, blue: lerpB)
                                let opacity = CGFloat(0).lerp(to: 1.0, alpha: alpha)
                                
                                let xDist = (CGFloat(gridX) + strideLength / 2)
                                    .distance(to: touchLocation.x)
                                let yDist = (CGFloat(gridY) + strideLength / 2)
                                    .distance(to: touchLocation.y)
                                
                                var dist = sqrt(xDist * xDist + yDist * yDist)
                                
                                if true {
                                    dist = dist.map(minRange: 0, maxRange: size.height, minDomain: 2.5, maxDomain: 0.1)
                                } else {
                                    dist = dist.map(minRange: 0, maxRange: size.height, minDomain: 0.1, maxDomain: 7.0)
                                }
                                innerInner.scaleBy(x: dist, y: dist)

                                innerInner.fill(Path(innerRect), with: .color(color.opacity(opacity)))
                            }
                            
                        }
                    }
                }
            }
            
            .background(Color(red: 89/255, green: 144/255, blue: 250/255).opacity(0.3))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                self.touchLocation = newValue.location
            })
            )
        }
    }
}

struct RotatingRects_Previews: PreviewProvider {
    static var previews: some View {
        RotatingRects()
    }
}
