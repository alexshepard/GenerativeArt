//
//  AlignmentGrid.swift
//  AlignmentGrid
//
//  Created by Alex Shepard on 7/23/21.
//

import SwiftUI

struct AlignmentGrid: View {
    public static let name = "Alignment in a grid"
    public static let date = "22 July 2021"
    
    // what js calls round, square, project, apple calls round, butt, square
    private var strokeCaps = ["Round", "Butt", "Square"]
    @State private var activeStrokeCap = 0
    @State private var tileCountX: CGFloat = 20
    @State private var lineWidthA: CGFloat = 5
    @State private var lineWidthB: CGFloat = 5
     
    func strokeCap(for value: Int) -> CGLineCap {
        if value == 0 {
            return .round
        } else if value == 1 {
            return .butt
        } else {
            return .square
        }
    }
    
    var body: some View {
        VStack {
            Picker("stroke cap", selection: $activeStrokeCap) {
                ForEach(0..<strokeCaps.count) {
                    Text(strokeCaps[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            GeometryReader { geom in
                Canvas { context, size in
                    // square tiles
                    let tileWidth = size.width / tileCountX
                    let tileCountY = size.height / tileWidth
                    
                    for gridY in 0..<Int(tileCountY) {
                        for gridX in 0..<Int(tileCountX) {
                            let x = size.width / tileCountX * CGFloat(gridX)
                            let y = size.height / tileCountY * CGFloat(gridY)
                            
                            var lineWidth: CGFloat = 0
                            let line = Path { path in
                                if Bool.random() {
                                    path.move(to: CGPoint(x: x, y: y))
                                    path.addLine(to: CGPoint(x: x + tileWidth, y: y + tileWidth))
                                    lineWidth = lineWidthA
                                } else {
                                    path.move(to: CGPoint(x: x + tileWidth, y: y))
                                    path.addLine(to: CGPoint(x: x, y: y + tileWidth))
                                    lineWidth = lineWidthB
                                }
                            }
                            
                            let strokeCap = self.strokeCap(for: self.activeStrokeCap)
                            let strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: strokeCap)
                            
                            context.stroke(line, with: .color(.gray), style: strokeStyle)
                        }
                    }
                }
                .frame(width: geom.size.width, height: geom.size.height)
                // simulate tap gesture, since we don't get tap location with
                // any of the swiftui tap gestures
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ newValue in
                                // map and clamp
                                self.lineWidthA = newValue.location.x.map(
                                    minRange: 0,
                                    maxRange: geom.size.width,
                                    minDomain: 1,
                                    maxDomain: 20
                                ).clamp(to: 1...20)
                                self.lineWidthB = newValue.location.y.map(
                                    minRange: 0,
                                    maxRange: geom.size.height,
                                    minDomain: 1,
                                    maxDomain: 20
                                ).clamp(to: 1...20)
                            })
                         )
            }
        }
    }
}

struct AlignmentGrid_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentGrid()
    }
}
