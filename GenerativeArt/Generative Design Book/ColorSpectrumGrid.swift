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
                    // there has to be a better way to do c-style for loops in swift, right?
                    // a foreach with a stride or soemthing?
                    var gridY = 0.0
                    var gridX = 0.0
                    while gridY < geom.size.height {
                        gridX = 0.0
                        while gridX < geom.size.width {
                            let hue = clamp(gridX / geom.size.height)
                            let saturation = 1-clamp(gridY / geom.size.height)
                            
                            let color = Color(hue: hue, saturation: saturation, brightness: 1.0)
                            let rect = CGRect(x: gridX, y: gridY, width: stepX, height: stepY)
                            let path = Path(rect)
                            context.fill(path, with:.color(color))
                            
                            gridX += stepX
                        }
                        gridY += stepY
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: geom.size.width, height: geom.size.height)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ newValue in
                                stepX = newValue.location.x
                                stepY = newValue.location.y
                            })
                )
            }
        }
    }
    
    func clamp(_ val: CGFloat, range: ClosedRange<CGFloat> = CGFloat(0)...CGFloat(1.0)) -> CGFloat {
        var newVal = val
        if newVal > range.upperBound {
            newVal = range.upperBound
        } else if newVal < range.lowerBound {
            newVal = range.lowerBound
        }
        return newVal
    }
}

struct ColorSpectrumGrid_Previews: PreviewProvider {
    static var previews: some View {
        ColorSpectrumGrid()
    }
}
