//
//  DumbAgents.swift
//  DumbAgents
//
//  Created by Alex Shepard on 8/25/21.
//

import SwiftUI

struct AgentShape {
    let point: CGPoint
    let size: CGSize
    let color: Color
}

struct DumbAgents: View, Sketch {
    public static var name = "Dumb Agents"
    public static var date = "25 Aug 2021"
    
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    @State private var agentShapes = [AgentShape]()
    @State private var rng = ArbitraryRandomNumberGenerator(seed: UInt64(941))

    var body: some View {
        GeometryReader { geom in
            Canvas { context, size in
                for shape in agentShapes {
                    var innerContext = context
                    innerContext.translateBy(x: shape.point.x, y: shape.point.y)
                    
                    let rect = CGRect(x: -shape.size.width/2,
                                      y: -shape.size.height/2,
                                      width: shape.size.width,
                                      height: shape.size.height)
                    
                    innerContext.fill(Path(ellipseIn: rect), with: .color(shape.color))
                }
            }
            .onAppear{
                setup(size: geom.size)
            }
            .onReceive(timer) { _ in
                guard let point = agentShapes.last?.point else {
                    return
                }
                let stepSize: CGFloat = 6
                let direction = Int.random(in: 0..<8, using: &rng)
                var nextPoint = point
                switch direction {
                case 0:
                    // north
                    nextPoint.y -= stepSize
                case 1:
                    // northeast
                    nextPoint.x += stepSize
                    nextPoint.y -= stepSize
                case 2:
                    // east
                    nextPoint.x += stepSize
                case 3:
                    // southeast
                    nextPoint.x += stepSize
                    nextPoint.y += stepSize
                case 4:
                    // south
                    nextPoint.y += stepSize
                case 5:
                    // southwest
                    nextPoint.x -= stepSize
                    nextPoint.y += stepSize
                case 6:
                    // west
                    nextPoint.x -= stepSize
                case 7:
                    // northwest
                    nextPoint.x -= stepSize
                    nextPoint.y -= stepSize
                default:
                    print("do nothing")
                    // do nothing
                }
                
                // handle underflow
                if nextPoint.x < 0 {
                    nextPoint.x = geom.size.width - nextPoint.x
                }
                if nextPoint.y < 0 {
                    nextPoint.y = geom.size.height - nextPoint.y
                }
                
                // handle overflow
                nextPoint.x = nextPoint.x.truncatingRemainder(dividingBy: geom.size.width)
                nextPoint.y = nextPoint.y.truncatingRemainder(dividingBy: geom.size.height)
                
                if Int.random(in: 0..<50, using: &rng) == 0 {
                    let size = Int.random(in: 16...32)
                    let hue = Double.random(in: 0.0...0.1)
                    let color = Color(hue: hue, saturation: 0.3, brightness: 0.4)
                    let shape = AgentShape(point: nextPoint, size: CGSize(width: size, height: size), color: color.opacity(0.1))
                    agentShapes.append(shape)
                } else {
                    let hue = Double.random(in: 0.0...0.1)
                    let color = Color(hue: hue, saturation: 0.8, brightness: 1.0)
                    
                    let shape = AgentShape(point: nextPoint, size: CGSize(width: 4, height: 4), color: color.opacity(0.1))
                    agentShapes.append(shape)
                }
            }
            .onTapGesture {
                setup(size: geom.size)
            }
        }
    }
    
    func setup(size: CGSize) {
        agentShapes.removeAll()
        let seed = Int.random(in: 0..<10000)
        rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let centerShape = AgentShape(point: center, size: CGSize(width: 4, height: 4), color: .black.opacity(0.1))
        agentShapes.append(centerShape)
    }
}

struct DumbAgents_Previews: PreviewProvider {
    static var previews: some View {
        DumbAgents()
    }
}
