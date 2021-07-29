//
//  ColorRulesTransparent.swift
//  ColorRulesTransparent
//
//  Created by Alex Shepard on 7/19/21.
//

import SwiftUI

struct ColorRulesTransparent: View, Sketch {
    public static let name = "Color palettes from rules, transparent"
    public static let date = "19 July 2021"

    @State private var hueValues = [Double]()
    @State private var saturationValues = [Double]()
    @State private var brightnessValues = [Double]()
        
    var colorCounts = [5, 50, 500, 5000]
    @State private var colorCount: Int = 0
    
    @State private var rows = Int.random(in: 2...20)
    
    func generateColors() {
        hueValues.removeAll()
        saturationValues.removeAll()
        brightnessValues.removeAll()
        
        for i in 0..<colorCounts[colorCount] {
            if i.isMultiple(of: 2) {
                hueValues.append(Double.random(in: 0...1))
                saturationValues.append(1)
                brightnessValues.append(Double.random(in: 0...1))
            } else {
                hueValues.append(0.5417)
                saturationValues.append(Double.random(in: 0...1))
                brightnessValues.append(1)
            }
        }
    }
    
    func shuffle() {
        generateColors()
        rows = Int.random(in: 2...20)
    }
    
    var body: some View {
        VStack {
            Picker("Color Count", selection: $colorCount) {
                ForEach(0..<colorCounts.count) { count in
                    Text("\(colorCounts[count])")
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: colorCount) { newValue in
                generateColors()
            }
            
            GeometryReader { geom in
                Canvas { context, size in
                    if self.hueValues.count == 0 {
                        return
                    }
                    
                    let rowHeight = size.height / CGFloat(rows)
                    
                    var colorIdx = 0
                    for row in 0..<rows {
                        var partCount = row + 1
                        var parts = [Double]()
                        
                        for _ in 0..<partCount {
                            if Double.random(in: 0...1) < 0.075 {
                                let fragments = Int.random(in: 2...20)
                                for _ in 0..<fragments {
                                    parts.append(Double.random(in: 0..<2))
                                }
                            } else {
                                parts.append(Double.random(in: 2..<20))
                            }
                        }
                        
                        partCount = parts.count
                        let sumParts = parts.reduce(0, { $0 + $1 })
                        
                        var nextX: CGFloat = 0
                        for i in 0..<parts.count {
                            
                            let x = nextX
                            let y = CGFloat(row) * rowHeight
                            let width = CGFloat(parts[i]).map(minRange: 0, maxRange: sumParts, minDomain: 0, maxDomain: size.width)
                            let height = rowHeight * 1.5
                            let rect = CGRect(x: x, y: y, width: width, height: height)
                            nextX = x + width

                            let hue = hueValues[colorIdx % colorCounts[colorCount]]
                            let sat = saturationValues[colorIdx % colorCounts[colorCount]]
                            let bri = brightnessValues[colorIdx % colorCounts[colorCount]]
                            let color = Color(hue: hue, saturation: sat, brightness: bri)
                            colorIdx += 1
                            
                            let gradientTop = CGPoint(x: rect.midX, y: rect.minY)
                            let gradientBottom = CGPoint(x: rect.midX, y: rect.maxY)
                            context.fill(Path(rect), with: .linearGradient(Gradient(colors: [.clear, color]), startPoint: gradientTop, endPoint: gradientBottom))
                        }
                    }
                }
                .background(Color.black)
                .frame(width: geom.size.width, height: geom.size.height)
                .onAppear(perform: {
                    self.shuffle()
                })
                .onTapGesture {
                    self.shuffle()
                }
            }
        }
    }
}

struct ColorRulesTransparent_Previews: PreviewProvider {
    static var previews: some View {
        ColorRulesTransparent()
    }
}
