//
//  ShapesFromAgents.swift
//  ShapesFromAgents
//
//  Created by Alex Shepard on 9/2/21.
//

import SwiftUI
import Accelerate

extension Path {
    // Catmull-Rom splines, closed or open
    // currently not working
    // from https://github.com/jnfisher/ios-curve-interpolation
    // but converted to Accelerate & swift
    // the accelerate bits require that CGPoint conform to AccelerateMutableBuffer
    // which is handled in this project in Extensions.swift
    init(interpolatingSplinesAlongRoute points: [CGPoint], closed: Bool, alpha: CGFloat) {
        assert(points.count >= 4, "must have 4 or more points")
        assert(alpha >= 0.0 && alpha <= 1.0, "alpha must be within 0.0 and 1.0, inclusive")

        self.init()
        
        let EPSILON = 1.0e-5
        
        let endIndex = closed ? points.count : points.count - 2
        let startIndex = closed ? 0 : 1
        
        for i in startIndex..<endIndex {
            let nexti = (i+1) % points.count
            let nextnexti = (nexti + 1) % points.count
            let previ = i-1 < 0 ? points.count - 1 : i-1
            
            let p0 = points[previ]
            let p1 = points[i]
            let p2 = points[nexti]
            let p3 = points[nextnexti]
            
            let d1 = p0.distance(to: p1)
            let d2 = p1.distance(to: p2)
            let d3 = p2.distance(to: p3)
            
            // default value of control point 1 is p1, if distance is close
            var control1 = p1
            if abs(d1) > EPSILON {
                vDSP.multiply(pow(d1, 2 * alpha), p2, result: &control1)
                vDSP.subtract(control1, vDSP.multiply(pow(d2, 2 * alpha), p0), result: &control1)
                vDSP.add(control1, vDSP.multiply(2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha), p1), result: &control1)
                vDSP.multiply(1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))), control1, result: &control1)
            }
            
            // default value of control point 2 is p2, if distance is close
            var control2 = p2
            if abs(d3) > EPSILON {
                vDSP.multiply(pow(d3, 2 * alpha), p1, result: &control2)
                vDSP.subtract(control2, vDSP.multiply(pow(d2, 2 * alpha), p3), result: &control2)
                vDSP.add(control2, vDSP.multiply(2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha), p2), result: &control2)
                vDSP.multiply(1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))), control2, result: &control2)
            }
            
            if i == startIndex {
                move(to: p1)
            }
            
            addCurve(to: p2, control1: control1, control2: control2)
        }
        
        if closed {
            closeSubpath()
        }
    }
}

struct ShapesFromAgents: View, Sketch {
    class Agent {
        var x: Double
        var y: Double
        
        init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }
        
    public static var name = "Shapes From Agents"
    public static var date = "2 Sept 2021"
    
    @State private var points = [CGPoint]()
    @State private var radius: Double = 50
    @State private var jitterAmt: Double = 1.0
    
    @State private var seed: Int = 941

    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { newValue in
                points.append(newValue.location)
            }
    }

    var body: some View {
        Canvas { context, size in
            var rng = ArbitraryRandomNumberGenerator(seed: UInt64(seed))
            
            if self.points.count > 4 {
                var agents = [Agent]()
                
                for degrees in stride(from: 0, through: 360 + 90, by: 45) {
                    let angle = Angle(degrees: Double(degrees))
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius
                    let agent = Agent(x: x, y: y)
                    agents.append(agent)
                }

                for i in 0..<points.count {
                    // draw a deforming circle around this point
                    let point = points[i]
                    
                    var circlePoints = [CGPoint]()
                    for agent in agents {
                        // nudge each agent its own way
                        agent.x += Double.random(in: -jitterAmt...jitterAmt, using: &rng)
                        agent.y += Double.random(in: -jitterAmt...jitterAmt, using: &rng)
                        
                        circlePoints.append(CGPoint(x: point.x + agent.x, y: point.y + agent.y))
                    }
                    
                    let path = Path(interpolatingSplinesAlongRoute: circlePoints, closed: false, alpha: 0.5)
                    context.stroke(path, with: .color(.black.opacity(0.3)))
                }
            }
        }
        .onTapGesture {
            points.removeAll()
            seed = Int.random(in: 0...40_000)
        }
        .gesture(drag)

    }
}

struct ShapesFromAgents_Previews: PreviewProvider {
    static var previews: some View {
        ShapesFromAgents()
    }
}
