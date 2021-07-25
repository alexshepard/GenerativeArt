//
//  AlignmentGridSymbols.swift
//  AlignmentGridSymbols
//
//  Created by Alex Shepard on 7/23/21.
//

import SwiftUI

struct AlignmentGridSymbols: View {
    public static let name = "Alignment in a grid, symbols"
    public static let date = "22 July 2021"
    
    private var symbols = [
        "line.diagonal",
        "circle.hexagongrid",
        "location.north.fill",
        "arrow.triangle.merge",
        "waveform",
        "touchid",
        "wifi",
        "gear",
        "eye.circle.fill",
        "tropicalstorm",
    ]
    @State private var symbol = 0
    
    private var sizeModes = [
        "rectangle.portrait",
        "rectangle.portrait.arrowtriangle.2.outward",
        "rectangle.portrait.arrowtriangle.2.inward",
    ]
    @State private var sizeMode = 0
    
    @State private var tileCountX: CGFloat = 10
    @State private var touchLocation: CGPoint = CGPoint.zero
    
    @State private var fgColor: Color = .black
    
    var body: some View {
        VStack {
            Picker("symbol", selection: $symbol) {
                ForEach(0..<symbols.count) {
                    Image(systemName: symbols[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Picker("sizemode", selection: $sizeMode) {
                ForEach(0..<sizeModes.count) {
                    Image(systemName: sizeModes[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()

            
            Canvas { context, size in
                let image = Image(systemName: symbols[symbol])
                    .symbolRenderingMode(.hierarchical)
                
                var symbol = context.resolve(image)
                symbol.shading = .color(fgColor.opacity(0.5))
                
                // square tiles
                let tileWidth = size.width / tileCountX
                let tileCountY = size.height / tileWidth
                
                for gridY in 0..<Int(tileCountY)+1 {
                    for gridX in 0..<Int(tileCountX)+1 {
                        var innerContext = context
                        
                        let x = size.width / tileCountX * CGFloat(gridX) + tileWidth / 2
                        let y = size.height / tileCountY * CGFloat(gridY) + tileWidth / 2
                        innerContext.translateBy(x: x, y: y)
                                                
                        if touchLocation != .zero {
                            var angle = Angle(radians: atan2(touchLocation.y - y, touchLocation.x - x))
                            angle += Angle.degrees(90.0)
                            innerContext.rotate(by: angle)
                            
                            if sizeMode != 0 {
                                let xDist = x.distance(to: touchLocation.x)
                                let yDist = y.distance(to: touchLocation.y)
                                
                                var dist = sqrt(xDist * xDist + yDist * yDist)
                                if sizeMode == 1 {
                                    dist = dist.map(minRange: 0, maxRange: size.height, minDomain: 7.0, maxDomain: 0.1)
                                } else {
                                    dist = dist.map(minRange: 0, maxRange: size.height, minDomain: 0.1, maxDomain: 7.0)
                                }
                                innerContext.scaleBy(x: dist, y: dist)
                            }
                        }
                        
                        innerContext.draw(symbol, at: CGPoint(x: 0, y: 0))
                    }
                }
            }
            
            .onTapGesture {
                fgColor = Color(hue: Double.random(in: 0...1),
                                saturation: Double.random(in: 0...1),
                                brightness: Double.random(in: 0...1))
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                self.touchLocation = newValue.location
            })
            )
        }
    }
}

struct AlignmentGridSymbols_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentGridSymbols()
    }
}
