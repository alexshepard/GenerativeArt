//
//  MySketchesMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI

struct MySketchesMenu: View {
    
    var jul2021Skektches: [Sketch.Type] = [
        AcrossShapes.self,
        AcrossComplementaryShapes.self,
        PerlinAcrossShapes.self,
        ColorFromCamera.self,
        AnimatedAcrossShapes.self,
        RotatingGrid.self,
    ]
    
    var aug2021Skektches: [Sketch.Type] = [
        LinesFromCamera.self,
        TogglesFromCamera.self,
    ]
    

    @ViewBuilder
    func buildView(sketches: [Any], index: Int) -> some View {
        switch sketches[index].self {
            
        case is AcrossShapes.Type: AcrossShapes()
        case is AcrossComplementaryShapes.Type: AcrossComplementaryShapes()
        case is PerlinAcrossShapes.Type: PerlinAcrossShapes()
        case is ColorFromCamera.Type: ColorFromCamera()
        case is AnimatedAcrossShapes.Type: AnimatedAcrossShapes()
        case is RotatingGrid.Type: RotatingGrid()
            
        case is LinesFromCamera.Type: LinesFromCamera()
        case is TogglesFromCamera.Type: TogglesFromCamera()
            
        default: EmptyView()
        }
    }

    
    var body: some View {
        List {
            Section("July 2021") {
                ForEach(0..<jul2021Skektches.count) { idx in
                    MenuItem(
                        view: AnyView(buildView(sketches: jul2021Skektches, index: idx)),
                        title: jul2021Skektches[idx].name,
                        creationDate: jul2021Skektches[idx].date
                    )
                }
            }
            
            Section("August 2021") {
                ForEach(0..<aug2021Skektches.count) { idx in
                    MenuItem(
                        view: AnyView(buildView(sketches: aug2021Skektches, index: idx)),
                        title: aug2021Skektches[idx].name,
                        creationDate: aug2021Skektches[idx].date
                    )
                }
            }
        }
        .navigationBarTitle("My Sketches", displayMode: .inline)
        .listStyle(.sidebar)
    }
}

struct MySketchesMenu_Previews: PreviewProvider {
    static var previews: some View {
        MySketchesMenu()
    }
}
