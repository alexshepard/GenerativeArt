//
//  Moire.swift
//  Moire
//
//  Created by Alex Shepard on 8/18/21.
//

import SwiftUI

struct Moire: View, Sketch {
    public static var name = "Moire"
    public static var date = "18 August 2021"

    private var shapes = ["circle.fill", "square.fill"]
    @State private var shape = 0
    @State private var touchLocation: CGPoint = .zero

    var body: some View {
        VStack {
            Picker("shape", selection: $shape) {
                ForEach(0..<shapes.count) {
                    Image(systemName: shapes[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if shape == 1 {
                Text("TBD")
            }
            
            Canvas { context, size in
                
                if shape == 0 {
                    let sideLength = min(size.width, size.height)
                    
                    var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    if size.height > size.width {
                        rect = rect.insetBy(dx: 0, dy: (size.height - size.width)/2)
                    } else {
                        rect = rect.insetBy(dx: 0, dy: (size.width - size.height)/2)
                    }
                    
                    for i in stride(from: 0, to: sideLength, by: 3) {
                        let insetRect = rect.insetBy(dx: i, dy: i)
                        var sat = CGFloat(i).map(minRange: 0, maxRange: sideLength, minDomain: 0, maxDomain: 1.0)
                        sat = sat.clamp(to: 0...1)
                        let color = Color(hue: 0.33, saturation: sat, brightness: 0.8)
                        context.stroke(Path(ellipseIn: insetRect), with: .color(color))
                    }
                    
                    // move left and right in relation to the x drag location
                    let offsetAmt = touchLocation.x.map(minRange: 0, maxRange: size.width, minDomain: -50, maxDomain: 50)
                    let offsetRect = rect.offsetBy(dx: offsetAmt, dy: 0)
                    
                    // scale up and down in relation to the y drag location
                    let scaleAmt = touchLocation.y.map(minRange: 0, maxRange: size.height, minDomain: 0.5, maxDomain: 1.2)
                    
                    for i in stride(from: 0, to: offsetRect.width, by: 3) {
                        let insetRect = offsetRect.insetBy(dx: i, dy: i)
                        
                        var innerContext = context
                        innerContext.translateBy(x: insetRect.midX, y: insetRect.midY)
                        innerContext.scaleBy(x: scaleAmt, y: scaleAmt)
                        
                        let innerRect = CGRect(x: -insetRect.size.width/2, y: -insetRect.size.height/2, width: insetRect.size.width, height: insetRect.size.height)
                        
                        var sat = CGFloat(i).map(minRange: 0, maxRange: offsetRect.width, minDomain: 0.0, maxDomain: 1.0)
                        sat = sat.clamp(to: 0...1)
                        let color = Color(hue: 0.38, saturation: sat, brightness: 0.8).opacity(0.7)

                        innerContext.stroke(Path(ellipseIn: innerRect), with: .color(color))
                    }
                }

            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                            self.touchLocation = newValue.location
                        })
            )
        }
    }
}

struct Moire_Previews: PreviewProvider {
    static var previews: some View {
        Moire()
    }
}
