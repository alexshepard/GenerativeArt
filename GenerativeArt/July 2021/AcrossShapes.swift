//
//  AcrossShapes.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI

struct AcrossShapes: View {
    
    var name = "Across Shapes"
    var date = "5 July 2021"
    
    let timer = Timer.publish(every: 1/10, on: .main, in: .common).autoconnect()
    
    @State private var path: Path = Path { path in
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 15, y: 15))
    }
    
    //var size: CGSize = CGSize(width: 400, height: 400)
    
    @State private var cPaths = [Path]()
    var c = Color(.sRGB, red: 0.2, green: 0.03, blue: 0.15, opacity: 0.10)
    
    @State private var c2Paths = [Path]()
    var c2 = Color(.sRGB, red: 0.4, green: 0.3, blue: 0.03, opacity: 0.10)
    
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
                .onReceive(timer) { input in
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
            } else {
                Text("ios 14 view")
                // Fallback on earlier versions
            }
        }
    }
}

struct AcrossShapes_Previews: PreviewProvider {
    static var previews: some View {
        AcrossShapes()
    }
}
