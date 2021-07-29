//
//  GenerativeDesignBookMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/6/21.
//

import SwiftUI

struct GenerativeDesignBookMenu: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                Section("Chapter One: Colors") {
                    MenuItem(view: AnyView(HelloColor()),
                             title: HelloColor.name,
                             creationDate: HelloColor.date)

                    MenuItem(view: AnyView(ColorSpectrumGrid()),
                             title: ColorSpectrumGrid.name,
                             creationDate: ColorSpectrumGrid.date)

                    MenuItem(view: AnyView(ColorSpectrumCircle()),
                             title: ColorSpectrumCircle.name,
                             creationDate: ColorSpectrumCircle.date)

                    MenuItem(view: AnyView(ColorPaletteInterpolation()),
                             title: ColorPaletteInterpolation.name,
                             creationDate: ColorPaletteInterpolation.date)

                    MenuItem(view: AnyView(RGBInterpolation()),
                             title: RGBInterpolation.name,
                             creationDate: RGBInterpolation.date)

                    MenuItem(view: AnyView(ColorFromImages()),
                             title: ColorFromImages.name,
                             creationDate: ColorFromImages.date)

                    MenuItem(view: AnyView(ColorRules()),
                             title: ColorRules.name,
                             creationDate: ColorRules.date)

                    MenuItem(view: AnyView(ColorRulesTransparent()),
                             title: ColorRulesTransparent.name,
                             creationDate: ColorRulesTransparent.date)

                    MenuItem(view: AnyView(ColorRulesDropout()),
                             title: ColorRulesDropout.name,
                             creationDate: ColorRulesDropout.date)

                }
                Section("Chapter Two: Shape") {
                    
                    MenuItem(view: AnyView(HelloShape()),
                             title: HelloShape.name,
                             creationDate: HelloShape.date)

                    MenuItem(view: AnyView(AlignmentGrid()),
                             title: AlignmentGrid.name,
                             creationDate: AlignmentGrid.date)

                    MenuItem(view: AnyView(AlignmentGridColor()),
                             title: AlignmentGridColor.name,
                             creationDate: AlignmentGridColor.date)

                    MenuItem(view: AnyView(AlignmentGridSymbols()),
                             title: AlignmentGridSymbols.name,
                             creationDate: AlignmentGridSymbols.date)
                    
                    MenuItem(view: AnyView(MovementGrid()),
                             title: MovementGrid.name,
                             creationDate: MovementGrid.date)
                    
                    MenuItem(view: AnyView(MovementGridUnder()),
                             title: MovementGridUnder.name,
                             creationDate: MovementGridUnder.date)
                    
                    MenuItem(view: AnyView(RadGrid()),
                             title: RadGrid.name,
                             creationDate: RadGrid.date)
                    
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
