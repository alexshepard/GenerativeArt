//
//  RotatingGrid.swift
//  RotatingGrid
//
//  Created by Alex Shepard on 7/25/21.
//

import SwiftUI

struct RotatingGrid: View, Sketch {
    public static let name = "Rotating in a grid"
    public static let date = "23 July 2021"

    @State private var tileCountX: CGFloat = 10

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                context.blendMode = .screen

                context.fill(Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)), with: .color(.black))
                let now = timeline.date.timeIntervalSinceReferenceDate
                let angle = Angle.degrees(now.remainder(dividingBy: 3) * 120)
                let x = cos(angle.radians)
                
                var symbol = context.resolve(Image(systemName: "circle.hexagongrid.fill"))
                
                let hue = Double(now.truncatingRemainder(dividingBy: 10)) / 10.0
                let saturation = 1.0
                let brightness = 1.0
                
                let color = Color(hue: hue, saturation: saturation, brightness: brightness).opacity(0.5)
                symbol.shading = .color(color)
                // square tiles
                let tileWidth = size.width / tileCountX
                let tileCountY = size.height / tileWidth
                
                
                var scale = 1.0
                var angle2 = Angle.degrees(5.0)
                
                for gridY in 0..<Int(tileCountY) {
                    for gridX in 0..<Int(tileCountX) {
                        var innerContext = context
                        
                        let x = size.width / tileCountX * CGFloat(gridX) + tileWidth / 2
                        let y = size.height / tileCountY * CGFloat(gridY) + tileWidth / 2
                        innerContext.translateBy(x: x, y: y)
                        innerContext.rotate(by: .degrees(now.remainder(dividingBy: 3) * 180))
                        innerContext.scaleBy(x: scale, y: scale)
                        
                        scale += 0.01

                        let rect = CGRect(x: -tileWidth / 2, y: -tileWidth / 2, width: tileWidth, height: tileWidth)
                        //context.stroke(Path(rect), with: .color(.blue))
                        //context.rotate(by: .degrees(1))
                        innerContext.draw(symbol, in: rect)
                    }
                }
            }
            
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged({ newValue in
                            print(newValue)
                        })
                     )
        }
    }
}

struct RotatingGrid_Previews: PreviewProvider {
    static var previews: some View {
        RotatingGrid()
    }
}
