//
//  DrawMoire.swift
//  DrawMoire
//
//  Created by Alex Shepard on 8/24/21.
//

import SwiftUI
import Accelerate

extension Path {
    // open Catmull-Rom splines
    // from https://github.com/jnfisher/ios-curve-interpolation
    // but converted to Accelerate & swift
    // the accelerate bits require that CGPoint conform to AccelerateMutableBuffer
    // which is handled in this project in Extensions.swift
    init(interpoloatingSplinesAlongRoute points: [CGPoint], alpha: CGFloat) {
        assert(points.count >= 4, "must have 4 or more points")
        assert(alpha >= 0.0 && alpha <= 1.0, "alpha must be within 0.0 and 1.0, inclusive")

        self.init()
        
        let EPSILON = 1.0e-5

        let endIndex = points.count - 2
        let startIndex = 1
        for i in startIndex..<endIndex {
            let nexti = i+1
            let nextnexti = nexti + 1
            let previ = i-1
            
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
    }
}

extension Path {
    init(parallelLinesAlongRoute points: [CGPoint]) {
        assert(points.count > 2, "must have 2 or more points")
        
        self.init()
        
        guard let first = points.first else { return }
        
        for i in stride(from: -40, through: 40, by: 4) {
            var iPoints = [CGPoint]()
            let origin = CGPoint(x: first.x, y: first.y + CGFloat(i))
            iPoints.append(origin)
            
            var prevPoint: CGPoint? = nil
            for point in points {
                if let prevPoint = prevPoint {
                    let angle = atan2(prevPoint.y - point.y, prevPoint.x - point.x)
                    let drawAngle = Angle(radians: angle) + Angle.degrees(90)
                    
                    let iPoint = CGPoint(x: point.x + (CGFloat(i) * cos(drawAngle.radians)),
                                         y: point.y + CGFloat(i) * sin(drawAngle.radians))
                    iPoints.append(iPoint)
                }
                prevPoint = point
            }
            
            addPath(Path(interpoloatingSplinesAlongRoute: iPoints, alpha: 0.5))
        }
    }
}

struct DrawMoire: View, Sketch {
    
    struct DrawShape {
        var points: [CGPoint]
        var color: Color
    }

    public static var name = "Draw Moire"
    public static var date = "24 August 2021"
    
    @State private var points = [CGPoint]()
    @State private var shapes = [DrawShape]()
    
    private var drawColors = ["Green", "Black"]
    @State private var drawColor = 0
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { newValue in
                points.append(newValue.location)
            }
            .onEnded { newValue in
                let shape = DrawShape(points: points, color: drawColor == 0 ? .green : .black)
                shapes.append(shape)
                points.removeAll()
            }
    }

    var body: some View {
        VStack {
            Picker("", selection: $drawColor) {
                ForEach(0..<drawColors.count) {
                    Text(drawColors[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Canvas { context, size in
                
                for shape in shapes {
                    if shape.points.count > 4 {
                        context.stroke(Path(parallelLinesAlongRoute: shape.points), with: .color(shape.color), lineWidth: 2)
                    }
                }
                
                if points.count > 4 {
                    context.stroke(Path(parallelLinesAlongRoute: points), with: .color(drawColor == 0 ? .green : .black), lineWidth: 2)
                }
            }
            .gesture(drag)
        }
    }
}

struct DrawMoire_Previews: PreviewProvider {
    static var previews: some View {
        DrawMoire()
    }
}
