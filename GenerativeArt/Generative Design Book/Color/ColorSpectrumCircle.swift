//
//  ColorSpectrumCircle.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import SwiftUI
import ModelIO

struct ColorSpectrumCircle: View {
    public static let name = "Color spectrum in a circle"
    public static let date = "11 July 2021"

    private var segmentsOptions = [360, 45, 24, 12, 6]
    @State private var segmentsChosen = 2
    @State private var touchX: CGFloat = 0
    @State private var touchY: CGFloat = 0
    
    var body: some View {
        VStack {
            Picker("Segments", selection: $segmentsChosen) {
                ForEach(0..<segmentsOptions.count) { idx in
                    Text("\(segmentsOptions[idx])")
                }
            }
            .padding()
            .pickerStyle(.segmented)
            
            GeometryReader { geom in
                if #available(iOS 15.0, *) {
                    Canvas { context, size in
                        let radius: CGFloat = size.width/2 - 20
                        let centerPt = CGPoint(x: size.width / 2, y: size.height / 2)
                        let angleStep: CGFloat = CGFloat(360) / CGFloat(segmentsOptions[segmentsChosen])
                        
                        for angle in stride(from: 0, through: 360, by: angleStep) {
                            // compute the two corners of our triangle (the third corner is the center)
                            let vx = size.width / 2 + cos( CGFloat(angle).deg2rad() ) * radius
                            let vy = size.height / 2 + sin( CGFloat(angle).deg2rad() ) * radius
                            let nextVx = size.width / 2 + cos( CGFloat(angle + angleStep).deg2rad() ) * radius
                            let nextVy = size.height / 2 + sin( CGFloat(angle + angleStep).deg2rad() ) * radius
                            
                            // build our triangle
                            let vertex = Path { path in
                                path.move(to: centerPt)
                                path.addLine(to: CGPoint(x: vx, y: vy))
                                path.addLine(to: CGPoint(x: nextVx, y: nextVy))
                            }

                            // setup the color based on the angle and the tap location
                            let hue = CGFloat(angle / 360).clamp()
                            let color = Color(hue: hue, saturation: 1 - touchX, brightness: 1 - touchY)
                            
                            
                            // stroke and fill otherwise there's a gap
                            context.stroke(vertex, with: .color(color))
                            context.fill(vertex, with: .color(color))
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geom.size.width, height: geom.size.height)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onChanged({ newValue in
                                    touchX = newValue.location.x.clamp(range: 1...geom.size.width) / geom.size.width
                                    touchY = newValue.location.y.clamp(range: 1...geom.size.height) / geom.size.height
                                })
                             )
                }
            }
        }
    }
}

struct ColorSpectrumCircle_Previews: PreviewProvider {
    static var previews: some View {
        ColorSpectrumCircle()
    }
}
