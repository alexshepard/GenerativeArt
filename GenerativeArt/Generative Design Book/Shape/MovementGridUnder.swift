//
//  MovementGridUnder.swift
//  MovementGridUnder
//
//  Created by Alex Shepard on 7/26/21.
//

import SwiftUI

import GameplayKit

struct MovementGridUnder: View {
    public static let name = "Movement in a grid, under"
    public static let date = "26 July 2021"
    
    @State private var touchLocation: CGPoint = .zero
    @State private var tileCountX: CGFloat = 10
    
    private var jitterOrientations = ["all", "horizontal", "vertical"]
    @State private var jitterOrientation = 0
    
    private var colorSchemes = ["black & white", "pink & violet"]
    @State private var colorScheme = 0

    @State private var rngSeed = 941
    
    var body: some View {
        VStack {
            Picker("jitter orientation", selection: $jitterOrientation) {
                ForEach(0..<jitterOrientations.count) {
                    Text(jitterOrientations[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Picker("color scheme", selection: $colorScheme) {
                ForEach(0..<colorSchemes.count) {
                    Text(colorSchemes[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()

            
            Canvas { context, size in
                
                context.blendMode = .screen
                
                var generator = ArbitraryRandomNumberGenerator(seed: UInt64(rngSeed))

                // square tiles
                let tileWidth = size.width / tileCountX
                let tileCountY = size.height / tileWidth
                
                for gridY in -1..<Int(tileCountY)+1 {
                    for gridX in -1..<Int(tileCountX)+1 {
                        var frontDotColor: Color = .white
                        var backDotColor: Color = .black
                        if colorScheme == 1 {
                            frontDotColor = .purple.opacity(0.3)
                            backDotColor = .pink.opacity(0.3)
                        }
                        
                        var innerContext = context
                        let x = size.width / tileCountX * CGFloat(gridX) + tileWidth / 2
                        let y = size.height / tileCountY * CGFloat(gridY) + tileWidth / 2
                        innerContext.translateBy(x: x, y: y)
                        
                        var scale: CGFloat = 1.0
                        
                        var jitter: CGPoint = .zero
                        if touchLocation != .zero {
                            scale = touchLocation.y
                                .map(minRange: 0, maxRange: size.height, minDomain: 0.5, maxDomain: 5.0)
                                .clamp(to: 0.5...5.0)
                            
                            let maxJitter = touchLocation.x / 20
                            jitter = CGPoint(x: CGFloat.random(in: -maxJitter...maxJitter, using: &generator),
                                             y: CGFloat.random(in: -maxJitter...maxJitter, using: &generator))
                            
                        }
                        
                        var jitterContext = innerContext
                        jitterContext.scaleBy(x: scale, y: scale)
                        
                        if jitterOrientation == 1 {
                            jitter.y = 0
                        } else if jitterOrientation == 2 {
                            jitter.x = 0
                        }
                        
                        var jitterRect = CGRect(x: -tileWidth / 2, y: -tileWidth / 2, width: tileWidth, height: tileWidth)
                        jitterRect = jitterRect.insetBy(dx: 4, dy: 4)
                        jitterRect = jitterRect.offsetBy(dx: jitter.x, dy: jitter.y)

                        jitterContext.fill(Path(ellipseIn: jitterRect), with: .color(backDotColor))
                        
                        var fixedRect = CGRect(x: -tileWidth / 2, y: -tileWidth / 2, width: tileWidth, height: tileWidth)
                        fixedRect = fixedRect.insetBy(dx: 10, dy: 10)

                        innerContext.fill(Path(ellipseIn: fixedRect), with: .color(frontDotColor))
                    }
                }
            }
            .onTapGesture {
                self.rngSeed = Int.random(in: 0..<10000)
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ newValue in
                                        self.touchLocation = newValue.location
                                    })
            )
        }
    }
}

struct MovementGridUnder_Previews: PreviewProvider {
    static var previews: some View {
        MovementGridUnder()
    }
}
