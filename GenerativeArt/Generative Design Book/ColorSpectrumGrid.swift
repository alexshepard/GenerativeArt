//
//  ColorSpectrumGrid.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import SwiftUI

struct ColorSpectrumGrid: View {
    public static let name = "Color spectrum in a grid"
    public static let date = "11 July 2021"
    
    @State private var stepX: CGFloat = 10
    @State private var stepY: CGFloat = 10
    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    for gridY in stride(from: 0, through: geom.size.height, by: stepY) {
                        for gridX in stride(from: 0, through: geom.size.width, by: stepX) {
                            let hue = (gridX / geom.size.height).clamp()
                            let saturation = 1 - (gridY / geom.size.height).clamp()
                            let color = Color(hue: hue, saturation: saturation, brightness: 1.0)
                            
                            let rect = CGRect(x: gridX, y: gridY, width: stepX, height: stepY)
                            
                            context.fill(Path(rect), with:.color(color))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: geom.size.width, height: geom.size.height)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ newValue in
                                stepX = newValue.location.x.clamp(range: 1...geom.size.width)
                                stepY = newValue.location.y.clamp(range: 1...geom.size.height)
                            })
                )
            }
        }
    }    
}

struct ColorSpectrumGrid_Previews: PreviewProvider {
    static var previews: some View {
        ColorSpectrumGrid()
    }
}
