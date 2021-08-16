//
//  TogglesFromCamera.swift
//  TogglesFromCamera
//
//  Created by Alex Shepard on 8/16/21.
//

import SwiftUI

struct TogglesFromCamera: View, Sketch {
    public static let name = "Toggles from camera"
    public static let date = "16 August 2021"
    
    @State private var threshold: Double = 0.5
    @State private var imageColors = [UIColor]()
    
    var modes = ["pixels", "toggles"]
    @State private var mode = 0
    // selfie
    @ObservedObject private var camera = CameraController(cameraPosition: .front, fps: 1)
    
    // timer to pull contents of camera and inject into imageColors
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var rows = 60
    private var cols = 30
    
    func isOn(row: Int, col: Int) -> Bool {
        if imageColors.count == 0 { return false }
        let idx = row * cols + col
        let color = imageColors[idx]
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let luminosity = 0.299 * r + 0.587 * g + 0.114 * b
        return luminosity < threshold
    }
    
    func color(row: Int, col: Int) -> Color {
        if imageColors.count == 0 { return .black }
        let idx = row * cols + col
        let color = imageColors[idx]
        return Color(uiColor: color)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $mode) {
                ForEach(0..<modes.count) {
                    Text(modes[$0])
                }
            }
            .pickerStyle(.segmented)
            
            Slider(value: $threshold, in: 0...1)
            
            if mode == 1 {
                VStack {
                    ForEach(0..<rows) { row in
                        HStack {
                            ForEach(0..<cols) { col in
                                //Toggle("", isOn: .constant(true))
                                Toggle("", isOn: .constant(isOn(row: row, col: col)))
                                    //.toggleStyle(SwitchToggleStyle(tint: color(row: row, col: col)))
                                    .toggleStyle(SwitchToggleStyle(tint: .black))
                                    .scaleEffect(x: 0.25, y: 0.25, anchor: .center)
                                    .frame(width: 5, height: 2)
                            }
                        }
                    }
                }
            } else {
                Canvas { context, size in
                    if imageColors.count == 0 { return }
                    
                    let tileHeight = size.height / CGFloat(rows)
                    let tileWidth = size.width / CGFloat(cols)
                    
                    var colorIdx = 0
                    for y in stride(from: 0, to: size.height, by: tileHeight) {
                        for x in stride(from: 0, to: size.width, by: tileWidth) {
                            let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                            let color = Color(uiColor: imageColors[colorIdx])
                            colorIdx += 1
                            context.stroke(Path(rect), with: .color(color))
                            context.fill(Path(rect), with: .color(color))
                        }
                    }
                }
            }
            
        }
        .background(.white)
        .onReceive(timer) { _ in
            guard let cgImage = camera.cgImage else { return }
            let colorGridSize = CGSize(width: cols, height: rows)
            self.imageColors = UIImage(cgImage: cgImage).allColors(size: colorGridSize) ?? []
        }
        .onAppear {
            camera.startCapture()
        }
        .onDisappear {
            camera.stopCapture()
        }
    }
}

struct TogglesFromCamera_Previews: PreviewProvider {
    static var previews: some View {
        TogglesFromCamera()
    }
}
