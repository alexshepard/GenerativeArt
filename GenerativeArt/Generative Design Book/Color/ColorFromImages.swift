//
//  ColorFromImages.swift
//  ColorFromImages
//
//  Created by Alex Shepard on 7/16/21.
//

import SwiftUI

struct ColorFromImages: View {
    public static let name = "Color palettes from images"
    public static let date = "16 July 2021"
    
    private let images = ["IMG_4113", "IMG_4115", "IMG_4117"]
    @State private var selectedImage = 0
    
    private let sorts = ["hue", "saturation", "brightness"]
    @State private var selectedSort = 0
        
    var body: some View {
        GeometryReader { geom in
            VStack {
                
                Picker("Image", selection: $selectedImage) {
                    ForEach(0..<images.count) { i in
                        Text(images[i])
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                
                Picker("Sort", selection: $selectedSort) {
                    ForEach(0..<sorts.count) { i in
                        Text(sorts[i])
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom])

                Image(images[selectedImage])
                    .resizable()
                    .scaledToFill()
                    .frame(width: geom.size.width, height: 300)
                    .clipped()
                if #available(iOS 15.0, *) {
                    Canvas { context, size in
                                                
                        if let uiimage = UIImage(named: images[selectedImage]),
                           let imageColors = uiimage.allColors()
                        {
                            let sortedColors = imageColors.sorted { cA, cB in
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

                            let tileWidth = size.width / 40
                            let tileHeight = size.height / 40
                            
                            var colorIdx = 0
                            for y in stride(from: 0, to: size.height, by: tileHeight) {
                                for x in stride(from: 0, to: size.width, by: tileWidth) {
                                    let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                                    let color = Color(uiColor: sortedColors[colorIdx])
                                    colorIdx += 1
                                    context.stroke(Path(rect), with: .color(color))
                                    context.fill(Path(rect), with: .color(color))
                                }
                            }
                        }
                    }
                    .frame(width: geom.size.width, height: 300)
                }
            }
        }
    }
}

struct ColorFromImages_Previews: PreviewProvider {
    static var previews: some View {
        ColorFromImages()
    }
}
