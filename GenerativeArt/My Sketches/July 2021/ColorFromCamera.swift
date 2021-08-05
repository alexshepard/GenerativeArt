//
//  ColorFromCamera.swift
//  ColorFromCamera
//
//  Created by Alex Shepard on 7/16/21.
//

import SwiftUI


struct ColorFromCamera: View, Sketch {
    public static let name = "Color palette from camera"
    public static let date = "16 July 2021"
    
    @ObservedObject private var camera = CameraController(cameraPosition: .back)
    
    @State private var sorting = false
    
    private let sorts = ["hue", "saturation", "brightness"]
    @State private var selectedSort = 0

    var body: some View {
        if #available(iOS 15.0, *) {
            VStack {
                Toggle("Sort Colors", isOn: $sorting)
                    .padding()
                Picker("Sort", selection: $selectedSort) {
                    ForEach(0..<sorts.count) { i in
                        Text(sorts[i])
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom])
                .disabled(!sorting)
                
                Canvas { context, size in
                    
                    // set this too high and you'll need to clamp the frames processed
                    // per second in the sample buffer callback above, or swiftui
                    // will start glitching
                    let colorGridSize = CGSize(width: 60, height: 100)
                    
                    if let cgImage = camera.cgImage,
                       let imageColors = UIImage(cgImage: cgImage).allColors(size: colorGridSize)
                    {
                        var colors = imageColors
                        if sorting {
                            colors = imageColors.sorted { cA, cB in
                                var hA: CGFloat = 0
                                var sA: CGFloat = 0
                                var bA: CGFloat = 0
                                cA.getHue(&hA, saturation: &sA, brightness: &bA, alpha: nil)
                                
                                var hB: CGFloat = 0
                                var sB: CGFloat = 0
                                var bB: CGFloat = 0
                                cB.getHue(&hB, saturation: &sB, brightness: &bB, alpha: nil)
                                
                                if self.selectedSort == 0 {
                                    return hA > hB
                                } else if self.selectedSort ==  1 {
                                    return sA > sB
                                } else {
                                    return bA > bB
                                }
                            }
                        }
                        
                        let tileWidth = size.width / colorGridSize.width
                        let tileHeight = size.height / colorGridSize.height
                        
                        var colorIdx = 0
                        for y in stride(from: 0, to: size.height, by: tileHeight) {
                            for x in stride(from: 0, to: size.width, by: tileWidth) {
                                let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                                let color = Color(uiColor: colors[colorIdx])
                                colorIdx += 1
                                context.stroke(Path(rect), with: .color(color))
                                context.fill(Path(rect), with: .color(color))
                            }
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
}


