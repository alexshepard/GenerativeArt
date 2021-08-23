//
//  DragMoire.swift
//  DragMoire
//
//  Created by Alex Shepard on 8/22/21.
//

import SwiftUI

extension Path {
    init(parallelLinesIn rect: CGRect, density: CGFloat) {
        self.init()
        
        print(rect.origin.x)
        for y in stride(from: 0, to: rect.size.height, by: density) {
            move(to: CGPoint(x: rect.origin.x, y: y))
            addLine(to: CGPoint(x: rect.width, y: y))
        }
    }
}

struct DragShape {
    let begin: CGPoint
    let end: CGPoint
    let width: CGFloat
    let color: Color
    let density: CGFloat
}

struct DragMoire: View, Sketch {
    public static var name = "Drag Moire"
    public static var date = "22 August 2021"
    
    @State private var dragShapes = [DragShape]()
    @State private var density: CGFloat = 2
    @State private var width: CGFloat = 60
    
    private var colors = ["Red", "Green", "Blue", "Black"]
    @State private var selectedColor = 0
    
    private var activeColor: Color {
        switch selectedColor {
        case 0:
            return .red
        case 1:
            return .green
        case 2:
            return .blue
        default:
            return .black
        }
    }
    
    @State private var activeDragShape: DragShape?
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { newValue in
                activeDragShape = DragShape(begin: newValue.startLocation, end: newValue.location, width: width, color: self.activeColor, density: density)
            }
            .onEnded { newValue in
                let dragShape = DragShape(begin: newValue.startLocation, end: newValue.location, width: width, color: self.activeColor, density: density)
                dragShapes.append(dragShape)
            }
    }

    var body: some View {
        VStack {
            Picker("", selection: $selectedColor) {
                ForEach(0..<colors.count) {
                    Text(colors[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Stepper("Density: \(density, specifier: "%.0f")", value: $density, in: 1...4)
                .padding(.horizontal)
            
            HStack {
                Text("Width \(width, specifier: "%.0f")")
                Slider(value: $width, in: 20...200)
            }
            .padding(.horizontal)
            
            
            Canvas { context, size in
                
                context.blendMode = .screen
                
                for dragShape in dragShapes {
                    let length = dragShape.begin.distance(to: dragShape.end)
                    
                    let angle = atan2(dragShape.end.y - dragShape.begin.y, dragShape.end.x - dragShape.begin.x) * 180 / .pi
                    var innerContext = context
                    
                    innerContext.translateBy(x: dragShape.begin.x, y: dragShape.begin.y)
                    innerContext.rotate(by: .degrees(angle))
                    
                    let rect = CGRect(x: 0, y: 0, width: length, height: dragShape.width)
                    
                    innerContext.stroke(Path(parallelLinesIn: rect, density: dragShape.density), with: .color(dragShape.color))
                }
                
                if let dragShape = activeDragShape {
                    let length = dragShape.begin.distance(to: dragShape.end)
                    
                    let angle = atan2(dragShape.end.y - dragShape.begin.y, dragShape.end.x - dragShape.begin.x) * 180 / .pi
                    var innerContext = context
                    
                    innerContext.translateBy(x: dragShape.begin.x, y: dragShape.begin.y)
                    innerContext.rotate(by: .degrees(angle))
                    
                    let rect = CGRect(x: 0, y: 0, width: length, height: dragShape.width)
                    
                    innerContext.stroke(Path(parallelLinesIn: rect, density: dragShape.density), with: .color(dragShape.color))

                }
            }
            .gesture(drag)
        }
    }
}

struct DragMoire_Previews: PreviewProvider {
    static var previews: some View {
        DragMoire()
    }
}
