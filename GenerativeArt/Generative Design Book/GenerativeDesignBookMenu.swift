//
//  GenerativeDesignBookMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

protocol Sketch {
    static var name: String { get }
    static var date: String { get }
}

struct GenerativeDesignBookMenu: View {
    
    var colorSketches: [Sketch.Type] = [
        HelloColor.self,
        ColorSpectrumGrid.self,
        ColorSpectrumCircle.self,
        ColorPaletteInterpolation.self,
        RGBInterpolation.self,
        ColorFromImages.self,
        ColorRules.self,
        ColorRulesTransparent.self,
        ColorRulesDropout.self,
    ]
    
    var shapeSketches: [Sketch.Type] = [
        HelloShape.self,
        AlignmentGrid.self,
        AlignmentGridColor.self,
        AlignmentGridSymbols.self,
        MovementGrid.self,
        MovementGridUnder.self,
        RadGrid.self,
        JitterQuads.self,
        ComplexModules.self,
    ]

    @ViewBuilder
    func buildView(sketches: [Any], index: Int) -> some View {
        switch sketches[index].self {
        case is HelloColor.Type: HelloColor()
        case is ColorSpectrumGrid.Type: ColorSpectrumGrid()
        case is ColorSpectrumCircle.Type: ColorSpectrumCircle()
        case is ColorPaletteInterpolation.Type: ColorPaletteInterpolation()
        case is RGBInterpolation.Type: RGBInterpolation()
        case is ColorFromImages.Type: ColorFromImages()
        case is ColorRules.Type: ColorRules()
        case is ColorRulesTransparent.Type: ColorRulesTransparent()
        case is ColorRulesDropout.Type: ColorRulesDropout()
            
        case is HelloShape.Type: HelloShape()
        case is AlignmentGrid.Type: AlignmentGrid()
        case is AlignmentGridColor.Type: AlignmentGridColor()
        case is AlignmentGridSymbols.Type: AlignmentGridSymbols()
        case is MovementGrid.Type: MovementGrid()
        case is MovementGridUnder.Type: MovementGridUnder()
        case is RadGrid.Type: RadGrid()
        case is JitterQuads.Type: JitterQuads()
        case is ComplexModules.Type: ComplexModules()

        default: EmptyView()
        }
    }
    
    func sketchName(sketches: [Sketch.Type], index: Int) -> String {
        return sketches[index].self.name
    }
    
    func sketchDate(sketches: [Sketch.Type], index: Int) -> String {
        return sketches[index].self.date
    }

    
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                Section("Chapter One: Colors") {
                    ForEach(0..<colorSketches.count) { idx in
                        MenuItem(
                            view: AnyView(buildView(sketches: colorSketches, index: idx)),
                            title: sketchName(sketches: colorSketches, index: idx),
                            creationDate: sketchDate(sketches: colorSketches, index: idx)
                        )
                    }
                }
                
                Section("Chapter Two: Shapes") {
                    ForEach(0..<shapeSketches.count) { idx in
                        MenuItem(
                            view: AnyView(buildView(sketches: shapeSketches, index: idx)),
                            title: sketchName(sketches: shapeSketches, index: idx),
                            creationDate: sketchDate(sketches: shapeSketches, index: idx)
                        )
                    }
                }
            }
            .navigationBarTitle("Generative Design", displayMode: .inline)
            .listStyle(.sidebar)
        } else {
            Text("iOS 14 Fallback view")
        }
    }
}

struct GenerativeDesignBookMenu_Previews: PreviewProvider {
    static var previews: some View {
        GenerativeDesignBookMenu()
    }
}
