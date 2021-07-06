//
//  AcrossComplementaryShapes.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI

// thanks paul!
extension Color {
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let c = UIColor(self)
        c.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

struct AcrossComplementaryShapes: View {
    public static let name = "Across Complementary Shapes"
    public static let date = "5 July 2021"
    
    let timer = Timer.publish(every: 1/10, on: .main, in: .common).autoconnect()
        
    @State private var cPaths = [Path]()
    @State private var c2Paths = [Path]()
    
    @State private var c: Color = Color.white
    @State private var c2: Color = Color.black
    
    init() {
        setupColors()
    }
    
    func setupColors() {
        let r = Double.random(in: 0..<1)
        let g = Double.random(in: 0..<1)
        let b = Double.random(in: 0..<1)
        let o = Double.random(in: 0..<1)
        
        self.c = Color(.sRGB, red: r, green: g, blue: b, opacity: o)
        self.c2 = Color(.sRGB, red: 1-r, green: 1-g, blue: 1-b, opacity: o)
    }
    
    var body: some View {
        GeometryReader { geom in
            if #available(iOS 15.0, *) {
                Canvas { context, size in
                    for i in 0..<cPaths.count {
                        context.fill(cPaths[i], with: .color(c))
                        context.fill(c2Paths[i], with: .color(c2))
                        
                        let trailsRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                        let trailsColor = Color.init(.sRGB, white: 1.0, opacity: 0.1)
                        context.stroke(Path.init(trailsRect), with: .color(trailsColor))
                    }
                }
                .background(Color.white)
                .onReceive(timer) { _ in
                    let x = CGFloat.random(in: 10 ..< geom.size.width - 10)
                    let y = CGFloat.random(in: 10 ..< geom.size.height - 10)
                    
                    let x2 = CGFloat.random(in: 10 ..< geom.size.width - 10)
                    let y2 = CGFloat.random(in: 10 ..< geom.size.height - 10)
                    
                    let path = Path { path in
                        path.move(to: CGPoint(x: 10, y: 10))
                        path.addLine(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x2, y: y2))
                        path.addLine(to: CGPoint(x: 10, y: 10))
                    }
                    cPaths.append(path)
                    if cPaths.count > 30 {
                        cPaths.remove(at: 0)
                    }
                    
                    let path2 = Path { path in
                        path.move(to: CGPoint(x: geom.size.width - 10, y: geom.size.height - 10))
                        path.addLine(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x2, y: y2))
                        path.addLine(to: CGPoint(x: geom.size.width - 10, y: geom.size.height - 10))
                    }
                    c2Paths.append(path2)
                    if c2Paths.count > 30 {
                        c2Paths.remove(at: 0)
                    }
                }
                .navigationBarItems(trailing: Button {
                    self.setupColors()
                } label: {
                    Image.init(systemName: "return")
                })
            } else {
                Text("ios 14 fallback view")
            }
        }
    }
}

struct AcrossComplementaryShapes_Previews: PreviewProvider {
    static var previews: some View {
        AcrossComplementaryShapes()
    }
}
