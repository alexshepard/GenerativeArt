//
//  LinesFromCamera.swift
//  LinesFromCamera
//
//  Created by Alex Shepard on 8/1/21.
//

import SwiftUI

struct LinesFromCamera: View, Sketch {
    public static let name = "Lines from camera"
    public static let date = "1 August 2021"
    
    // selfie
    @ObservedObject private var camera = CameraController(cameraPosition: .front)
    
    var body: some View {
        Canvas { context, size in
            let colorGridSize = CGSize(width: 20, height: 30)
            
            if let cgImage = camera.cgImage,
               let imageColors = UIImage(cgImage: cgImage).allColors(size: colorGridSize)
            {
                let tileWidth = size.width / colorGridSize.width
                let tileHeight = size.height / colorGridSize.height
                
                var colorIdx = 0
                for y in stride(from: 0, to: size.height, by: tileHeight) {
                    for x in stride(from: 0, to: size.width, by: tileWidth) {
                        let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                        let uiColor = imageColors[colorIdx]
                        var r: CGFloat = 0
                        var g: CGFloat = 0
                        var b: CGFloat = 0
                        var a: CGFloat = 0
                        
                        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
                        let luminosity = 0.299 * r + 0.587 * g + 0.114 * b
                        let color = Color(white: luminosity)
                        
                        colorIdx += 1
                        context.stroke(Path(rect), with: .color(color))
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
        }
        .onAppear {
            camera.startCapture()
        }
        .onDisappear {
            camera.stopCapture()
        }
    }
}

struct LinesFromCamera_Previews: PreviewProvider {
    static var previews: some View {
        LinesFromCamera()
    }
}
