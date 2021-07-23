//
//  HelloShape.swift
//  HelloShape
//
//  Created by Alex Shepard on 7/20/21.
//

import SwiftUI

struct HelloShape: View {
    public static let name = "Hello, shape"
    public static let date = "20 July 2021"
    
    @State private var circleResolution: Int = 25
    @State private var radius: CGFloat = 150
    
    @State private var paths = [Path]()
    @State private var hues = [Double]()
    
    var body: some View {
        GeometryReader { geom in
            Canvas { context, size in
                let rect = CGRect(origin: .zero, size: size)
                let midPoint = CGPoint(x: rect.midX, y: rect.midY)
                let angle: CGFloat = 2 * .pi / CGFloat(circleResolution)
                
                var connected = Path()
                for i in 0...circleResolution {
                    let x = cos(angle * CGFloat(i)) * radius
                    let y = sin(angle * CGFloat(i)) * radius
                    let lineEnd = CGPoint(x: x + midPoint.x, y: y + midPoint.y)
                    
                    if connected.isEmpty {
                        connected.move(to: lineEnd)
                    } else {
                        connected.addLine(to: lineEnd)
                    }
                    
                    var path = Path()
                    path.move(to: midPoint)
                    path.addLine(to: lineEnd)
                    
                    //context.stroke(path, with: .color(.blue), style: StrokeStyle(lineWidth: 5))
                }
                
                for i in 0..<paths.count {
                    let color = Color(hue: hues[i], saturation: 0.5, brightness: 0.3).opacity(0.3)
                    let path = paths[i]
                    context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2))
                }

                
            }
            .drawingGroup()
            .frame(width: geom.size.width, height: geom.size.height)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged({ newValue in
                
                            let touchY = newValue.location.y.clamp(to: geom.safeAreaInsets.top...geom.size.height)
                            circleResolution = Int(touchY.map(minRange: geom.safeAreaInsets.top, maxRange: geom.size.height - geom.safeAreaInsets.bottom - geom.safeAreaInsets.top , minDomain: 2, maxDomain: 10))
                            
                            let touchX = newValue.location.x.clamp(to: 1...geom.size.width)
                            radius = touchX - geom.size.width / 2 + 0.5
                            let hue = radius.map(minRange: 0, maxRange: geom.size.width, minDomain: 0, maxDomain: 1)
                            self.hues.append(hue)
                            
                            let rect = CGRect(origin: .zero, size: geom.size)
                            let midPoint = CGPoint(x: rect.midX, y: rect.midY)
                            let angle: CGFloat = 2 * .pi / CGFloat(circleResolution)
                            
                            var connected = Path()
                            for i in 0...circleResolution {
                                let x = cos(angle * CGFloat(i)) * radius
                                let y = sin(angle * CGFloat(i)) * radius
                                let lineEnd = CGPoint(x: x + midPoint.x, y: y + midPoint.y)
                                
                                if connected.isEmpty {
                                    connected.move(to: lineEnd)
                                } else {
                                    connected.addLine(to: lineEnd)
                                }
                            }
                            paths.append(connected)
                        })
            )
        }
    }
}

struct HelloShape_Previews: PreviewProvider {
    static var previews: some View {
        HelloShape()
    }
}
