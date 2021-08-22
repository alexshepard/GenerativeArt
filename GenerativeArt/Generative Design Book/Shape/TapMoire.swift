//
//  TapMoire.swift
//  TapMoire
//
//  Created by Alex Shepard on 8/21/21.
//

import SwiftUI

struct TapMoire: View, Sketch {
    public static var name = "Tap Moire"
    public static var date = "21 August 2021"
    
    @State private var rects = [CGRect]()
    @State private var density = 2
    @State private var seed: Int = 941

    var body: some View {
        GeometryReader { geom in
            Canvas { context, size in
                var rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
                
                let baseHue = Double.random(in: 0...1, using: &rng)
                
                for rect in rects {
                    var hue = baseHue + Double.random(in: -0.25...0.25, using: &rng)
                    hue = hue.clamp(to: 0...1)

                    let up = Bool.random(using: &rng)
                    for i in stride(from: 0, to: Int(rect.size.width), by: density) {
                        var saturation: CGFloat = 0
                        if up {
                            saturation = CGFloat(i).map(minRange: 0, maxRange: rect.size.width, minDomain: 0.4, maxDomain: 0.7)
                        } else {
                            saturation = CGFloat(i).map(minRange: 0, maxRange: rect.size.width, minDomain: 0.3, maxDomain: 0.6)
                        }
                        
                        let color = Color(hue: hue, saturation: saturation, brightness: 0.9)

                        let innerRect = rect.insetBy(dx: CGFloat(i), dy: CGFloat(i))
                        context.stroke(Path(ellipseIn: innerRect), with: .color(color))
                    }
                }
            }
            .onAppear {
                let rectSide = min(geom.size.width, geom.size.height)
                let rect = CGRect(x: 0, y: geom.size.height/2 - rectSide/2, width: rectSide, height: rectSide)
                self.rects.append(rect)
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ drag in
                            let radius = CGFloat.random(in: 5...250)
                            let rect = CGRect(x: drag.location.x - radius/2,
                                              y: drag.location.y - radius/2,
                                              width: radius,
                                              height: radius)
                            rects.append(rect)
                        })
                     )
            .toolbar(content: {
                HStack {
                    Button {
                        self.seed = Int.random(in: 0...44_000)
                    } label: {
                        Image(systemName: "restart.circle")
                    }
                    
                    Button {
                        self.rects.removeAll()
                    } label: {
                        Image(systemName: "clear")
                    }
                }
            })
        }
    }
}

struct TapMoire_Previews: PreviewProvider {
    static var previews: some View {
        TapMoire()
    }
}
