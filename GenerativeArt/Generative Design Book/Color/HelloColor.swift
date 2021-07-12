//
//  HelloColor.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import SwiftUI

struct HelloColor: View {
    public static let name = "Hello, color"
    public static let date = "11 July 2021"
    
    @State private var fgColor: Color = .white
    @State private var bgColor: Color = .white
    @State private var rectSideLength: CGFloat = 0
    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    // center the rectangle
                    let originX = (geom.size.width - rectSideLength) / 2
                    let originY = (geom.size.height - rectSideLength) / 2
                    let rect = CGRect(x: originX, y: originY, width: rectSideLength, height: rectSideLength)
                    let path = Path(rect)
                    context.fill(path, with: .color(fgColor))
                }
                .edgesIgnoringSafeArea(.all)
                .background(bgColor)
                .frame(width: geom.size.width, height: geom.size.height)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ newValue in
                    let hue = (newValue.location.y / geom.size.height).clamp()
                    fgColor = Color(hue: hue, saturation: 1.0, brightness: 1.0)
                    bgColor = Color(hue: 1-hue, saturation: 1.0, brightness: 1.0)
                    rectSideLength = (newValue.location.x / geom.size.width).clamp() * geom.size.width
                })
                )
            }
        }
    }
}

struct HelloColor_Previews: PreviewProvider {
    static var previews: some View {
        HelloColor()
    }
}
