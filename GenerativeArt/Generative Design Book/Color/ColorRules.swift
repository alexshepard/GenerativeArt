//
//  ColorRules.swift
//  ColorRules
//
//  Created by Alex Shepard on 7/18/21.
//

import SwiftUI



struct ColorRules: View {
    public static let name = "Color palettes from rules"
    public static let date = "18 July 2021"
    
    @State private var hueValues = [Double]()
    @State private var saturationValues = [Double]()
    @State private var brightnessValues = [Double]()
    
    @State private var tileCountX = 50
    @State private var tileCountY = 5
    
    var rules = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    @State private var rule = 0
    
    init() {
        for _ in 0 ... (100 *  10) {
            hueValues.append(Double.random(in: 0..<1))
            saturationValues.append(Double.random(in: 0..<1))
            brightnessValues.append(Double.random(in: 0..<1))
        }
    }
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                Picker("Rule", selection: $rule) {
                    ForEach(0..<rules.count) { rule in
                        Text(rules[rule])
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                GeometryReader { geom in
                    Canvas { context, size in
                        if hueValues.count == 0 {
                            return
                        }
                        
                        let tileWidth = geom.size.width / CGFloat(tileCountX)
                        let tileHeight = geom.size.height / CGFloat(tileCountY)
                        var counter = 0
                        for y in 0..<tileCountY {
                            for x in 0..<tileCountX {
                                let rect = CGRect(x: tileWidth * CGFloat(x), y: tileHeight * CGFloat(y), width: tileWidth, height: tileHeight)
                                let color = Color(hue: hueValues[counter], saturation: saturationValues[counter], brightness: brightnessValues[counter])
                                context.stroke(Path(rect), with: .color(color))
                                context.fill(Path(rect), with: .color(color))
                                counter += 1
                            }
                            
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ newValue in
                        self.tileCountX = Int(newValue.location.x.map(
                            minRange: 0,
                            maxRange: geom.size.width,
                            minDomain: 2,
                            maxDomain: 100
                        ).clamp(to: 2...100))
                        self.tileCountY = Int(newValue.location.y.map(
                            minRange: 0,
                            maxRange: geom.size.height,
                            minDomain: 2,
                            maxDomain: 10
                        ).clamp(to: 2...10))
                    }))
                    .onChange(of: rule) { newValue in
                        print("rule changed")
                        hueValues.removeAll()
                        saturationValues.removeAll()
                        brightnessValues.removeAll()
                        if rule == 0 {
                            for i in 0 ... (100 * 10) {
                                if i.isMultiple(of: 2) {
                                    hueValues.append(0.389)
                                    saturationValues.append(Double.random(in: 0.3...1.0))
                                    brightnessValues.append(Double.random(in: 0.4...1.0))
                                } else {
                                    hueValues.append(0.583)
                                    saturationValues.append(Double.random(in: 0.4...1.0))
                                    brightnessValues.append(Double.random(in: 0.5...1.0))
                                }
                            }
                        } else if rule == 1 {
                            for _ in 0 ... (100 *  10) {
                                hueValues.append(Double.random(in: 0..<1))
                                saturationValues.append(Double.random(in: 0..<1))
                                brightnessValues.append(Double.random(in: 0..<1))
                            }
                        } else if rule == 2 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0..<1))
                                saturationValues.append(Double.random(in: 0..<1))
                                brightnessValues.append(1)
                            }
                        } else if rule == 3 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0..<1))
                                saturationValues.append(1)
                                brightnessValues.append(Double.random(in: 0..<1))
                            }
                        } else if rule == 4 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(0)
                                saturationValues.append(0)
                                brightnessValues.append(Double.random(in: 0..<1))
                            }
                        } else if rule == 5 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0..<0.5417))
                                saturationValues.append(1)
                                brightnessValues.append(Double.random(in: 0..<1))
                            }
                        } else if rule == 6 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0..<0.5417))
                                saturationValues.append(Double.random(in: 0..<1))
                                brightnessValues.append(1)
                            }
                        } else if rule == 7 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0..<0.5))
                                saturationValues.append(Double.random(in: 0.8..<1))
                                brightnessValues.append(Double.random(in: 0.5..<0.9))
                            }
                        } else if rule == 8 {
                            for _ in 0 ... (100 * 10) {
                                hueValues.append(Double.random(in: 0.5..<1.0))
                                saturationValues.append(Double.random(in: 0.8..<1))
                                brightnessValues.append(Double.random(in: 0.5..<0.9))
                            }
                        } else {
                            for i in 0 ... (100 * 10) {
                                if i.isMultiple(of: 2) {
                                    hueValues.append(Double.random(in: 0..<1))
                                    saturationValues.append(1)
                                    brightnessValues.append(Double.random(in: 0..<1))
                                } else {
                                    hueValues.append(0.5417)
                                    saturationValues.append(Double.random(in: 0..<1))
                                    brightnessValues.append(1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ColorRules_Previews: PreviewProvider {
    static var previews: some View {
        ColorRules()
    }
}
