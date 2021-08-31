//
//  IntelligentAgents.swift
//  IntelligentAgents
//
//  Created by Alex Shepard on 8/30/21.
//

import SwiftUI
import Accelerate

enum CardinalDirection: CaseIterable {
    case south, west, north, east
}

struct AgentLine {
    let origin: CGPoint
    let end: CGPoint
    let width: CGFloat
    let color: Color
}

struct IntelligentAgents: View, Sketch {
    public static var name = "Intelligent Agents"
    public static var date = "30 Aug 2021"
    
    @State private var currentOrigin = CGPoint.zero
    @State private var currentAngle = Angle.zero
    @State private var currentSteps: Double = 0
    @State private var stepSize: Double = 4
    @State private var angleCount: Double = 7
    
    private var colorModes = ["Black", "Warm", "Cool"]
    @State private var colorMode = 0
    
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    @State private var currentPoint = CGPoint.zero
    @State private var lines = [AgentLine]()
    
    var body: some View {
        VStack {
            Picker("colorMode", selection: $colorMode) {
                ForEach(0..<colorModes.count) {
                    Text(colorModes[$0])
                }
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .bottom])
            
            Stepper("\(angleCount, specifier: "%g") angles", value: $angleCount, in: 2...7)
                .padding(.horizontal)
            
            GeometryReader { geom in
                Canvas { context, size in
                    
                    for line in lines {
                        let path = Path { path in
                            path.move(to: line.origin)
                            path.addLine(to: line.end)
                        }
                        context.stroke(path, with: .color(line.color), lineWidth: line.width)
                    }
                    
                    let path = Path { path in
                        path.move(to: currentOrigin)
                        path.addLine(to: currentPoint)
                    }
                    context.stroke(path, with: .color(.blue), style: StrokeStyle(dash: [2, 2]))
                }
                .onAppear {
                    currentOrigin = CGPoint(x: geom.size.width / 2, y: geom.size.height / 2)
                    currentPoint = currentOrigin
                    currentAngle = self.getRandomAngle(direction: .north)
                    currentAngle = Angle(degrees: Double.random(in: 0...360))
                }
                .onReceive(timer) { _ in
                    currentSteps += 1
                    
                    let x = currentOrigin.x + (cos(currentAngle.radians) * currentSteps * stepSize)
                    let y = currentOrigin.y + (sin(currentAngle.radians) * currentSteps * stepSize)
                    
                    currentPoint = CGPoint(x: x, y: y)
                    
                    // check if the point intersects (ie is very close to) any existing lines
                    for line in lines {
                        let distance = distanceFromPoint(point: currentPoint, toLineSegment: line.origin, and: line.end)
                        if distance < 1 {
                            let distance = currentOrigin.distance(to: currentPoint)
                            let lineWidth = distance / 50
                            
                            var color = Color.black
                            if colorMode == 1 {
                                color = Color(hue: 52/360, saturation: 1.0, brightness: (distance / 4) / 100)
                            } else if colorMode == 2 {
                                color = Color(hue: 192/360, saturation: 1.0, brightness: 0.64, opacity: (distance / 4) / 100)
                            }

                            self.lines.append(AgentLine(origin: currentOrigin, end: currentPoint, width: lineWidth, color: color))
                            
                            currentSteps = 0
                            currentOrigin = currentPoint
                            let direction = CardinalDirection.allCases.randomElement()
                            currentAngle = getRandomAngle(direction: direction ?? .north)
                        }
                    }
                    
                    // check if at edge
                    var makeNewLine = false
                    var direction: CardinalDirection = .north
                    if x <= 10 {
                        makeNewLine = true
                        direction = .east
                    } else if x >= geom.size.width - 10 {
                        makeNewLine = true
                        direction = .west
                    } else if y <= 10 {
                        makeNewLine = true
                        direction = .south
                    } else if y >= geom.size.height - 10 {
                        makeNewLine = true
                        direction = .north
                    }
                    
                    if makeNewLine {
                        let distance = currentOrigin.distance(to: currentPoint)
                        let lineWidth = distance / 50
                        
                        var color = Color.black
                        if colorMode == 1 {
                            color = Color(hue: 52/360, saturation: 1.0, brightness: (distance / 4) / 100)
                        } else if colorMode == 2 {
                            color = Color(hue: 192/360, saturation: 1.0, brightness: 0.64, opacity: (distance / 4) / 100)
                        }
                        
                        self.lines.append(AgentLine(origin: currentOrigin, end: currentPoint, width: lineWidth, color: color))
                        
                        currentSteps = 0
                        currentOrigin = currentPoint
                        currentAngle = getRandomAngle(direction: direction)
                    }

                }
            }
            
        }
        .toolbar {
            Button {
                self.currentOrigin = self.currentPoint
                self.currentSteps = 0
                self.lines.removeAll()
            } label: {
                Image(systemName: "delete.left")
                Text("Clear")
            }

        }
    }
    
    func getRandomAngle(direction: CardinalDirection) -> Angle {
        let choice = (floor(Double.random(in: -angleCount...angleCount) + 0.5)) * 90 / angleCount
        let angle = Angle(degrees: choice)
        
        switch direction {
        case .north:
            return angle - Angle(degrees: 90)
        case .west:
            return angle + Angle(degrees: 180)
        case .south:
            return angle + Angle(degrees: 90)
        case .east:
            return angle
        }
    }
    
    // with thanks to https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment/27737081#27737081
    // and https://stackoverflow.com/questions/28505344/shortest-distance-from-cgpoint-to-segment
    func distanceFromPoint(point: CGPoint, toLineSegment l1: CGPoint, and l2: CGPoint) -> CGFloat {
        let p_to_l1_xdist = point.x - l1.x
        let p_to_l1_ydist = point.y - l1.y
        let l2_to_l1_xdist = l2.x - l1.x
        let l2_to_l1_ydist = l2.y - l1.y
        
        let dot_product = p_to_l1_xdist * l2_to_l1_xdist + p_to_l1_ydist * l2_to_l1_ydist
        let line_len_sq = l2_to_l1_xdist * l2_to_l1_xdist + l2_to_l1_ydist * l2_to_l1_ydist
        let param = dot_product / line_len_sq

        // calculate the intersection of the normal to l1_l2 that goes through point
        var intersecting_x, intersecting_y: CGFloat
        
        if param < 0 || (l1.x == l2.x && l1.y == l2.y) {
            intersecting_x = l1.x
            intersecting_y = l1.y
        } else if param > 1 {
            intersecting_x = l1.x
            intersecting_y = l2.y
        } else {
            intersecting_x = l1.x + param * l2_to_l1_xdist
            intersecting_y = l1.y + param * l2_to_l1_ydist
        }

        let dx = point.x - intersecting_x
        let dy = point.y - intersecting_y
        
        return sqrt(dx * dx + dy * dy)
    }

}

struct IntelligentAgents_Previews: PreviewProvider {
    static var previews: some View {
        IntelligentAgents()
    }
}
