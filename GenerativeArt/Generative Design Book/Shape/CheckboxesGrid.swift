//
//  CheckboxesGrid.swift
//  CheckboxesGrid
//
//  Created by Alex Shepard on 8/16/21.
//

import SwiftUI

struct CheckboxesGrid: View, Sketch {
    public static var name = "Checkboxes in a grid"
    public static var date = "16 August 2021"
    
    private let images = ["IMG_4113", "IMG_4115", "IMG_4117"]
    @State private var selectedImage = 0
    
    @State private var threshold: Double = 0.0
    
    @State private var imageColors = [UIColor]()
    
    func isOn(row: Int, col: Int) -> Bool {
        if imageColors.count == 0 { return false }
        print(imageColors.count)
        let idx = row * 8 + col
        print(idx)
        let color = imageColors[idx]
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let luminosity = 0.299 * r + 0.587 * g + 0.114 * b
        return luminosity < threshold
    }
    
    var body: some View {
        let image = Binding<Int>(
            get: {
                self.selectedImage
            },
            set: {
                self.selectedImage = $0
                if let uiImage = UIImage(named: images[selectedImage]),
                   let cgImage = uiImage.cgImage
                {
                    let colorGridSize = CGSize(width: 8, height: 12)
                    self.imageColors = UIImage(cgImage: cgImage).allColors(size: colorGridSize) ?? []
                }
            }
        )

        
        VStack {
            Picker("Image", selection: image) {
                ForEach(0..<images.count) { i in
                    Text(images[i])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Slider(value: $threshold, in: 0...1)
            
            ZStack {
                Color.black
                
                Image(images[selectedImage])
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 300)
            
            VStack {
                ForEach(0..<12) { row in
                    HStack {
                        ForEach(0..<8) { col in
                            Toggle("", isOn: .constant(isOn(row: row, col: col)))
                                .frame(maxWidth: 40, maxHeight: 22)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                    }
                }
            }
        }
    }
}

struct CheckboxesGrid_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxesGrid()
    }
}
