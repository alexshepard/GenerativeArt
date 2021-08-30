//
//  GenerativeDesignBookMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

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
        LineModules.self,
        DiamondModules.self,
        CorridorModules.self,
        DarkeningCircles.self,
        RotatingRects.self,
        CheckboxesGrid.self,
        Moire.self,
        TapMoire.self,
        DragMoire.self,
        DrawMoire.self,
        DumbAgents.self,
        IntelligentAgents.self,
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
        case is LineModules.Type: LineModules()
        case is DiamondModules.Type: DiamondModules()
        case is CorridorModules.Type: CorridorModules()
        case is DarkeningCircles.Type: DarkeningCircles()
        case is RotatingRects.Type: RotatingRects()
        case is CheckboxesGrid.Type: CheckboxesGrid()
        case is Moire.Type: Moire()
        case is TapMoire.Type: TapMoire()
        case is DragMoire.Type: DragMoire()
        case is DrawMoire.Type: DrawMoire()
        case is DumbAgents.Type: DumbAgents()
        case is IntelligentAgents.Type: IntelligentAgents()
        
        default: EmptyView()
        }
    }
    
    
    var body: some View {
        List {
            Section("Chapter One: Colors") {
                ForEach(0..<colorSketches.count) { idx in
                    MenuItem(
                        view: AnyView(buildView(sketches: colorSketches, index: idx)),
                        title: colorSketches[idx].name,
                        creationDate: colorSketches[idx].date
                    )
                }
            }
            
            Section("Chapter Two: Shapes") {
                ForEach(0..<shapeSketches.count) { idx in
                    MenuItem(
                        view: AnyView(buildView(sketches: shapeSketches, index: idx)),
                        title: shapeSketches[idx].name,
                        creationDate: shapeSketches[idx].date
                    )
                }
            }
        }
        .navigationBarTitle("Generative Design", displayMode: .inline)
        .listStyle(.sidebar)
    }
}

struct GenerativeDesignBookMenu_Previews: PreviewProvider {
    static var previews: some View {
        GenerativeDesignBookMenu()
    }
}
