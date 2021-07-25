//
//  MySketchesMenu.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/5/21.
//

import SwiftUI

struct MySketchesMenu: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                Section("July 2021") {
                    MenuItem(view: AnyView(AcrossShapes()),
                             title: AcrossShapes.name,
                             creationDate: AcrossShapes.date)
                    
                    MenuItem(view: AnyView(AcrossComplementaryShapes()),
                             title: AcrossComplementaryShapes.name,
                             creationDate: AcrossComplementaryShapes.date)

                    MenuItem(view: AnyView(PerlinAcrossShapes()),
                             title: PerlinAcrossShapes.name,
                             creationDate: PerlinAcrossShapes.date)
                    
                    MenuItem(view: AnyView(ColorFromCamera()),
                             title: ColorFromCamera.name,
                             creationDate: ColorFromCamera.date)

                    MenuItem(view: AnyView(AnimatedAcrossShapes()),
                             title: AnimatedAcrossShapes.name,
                             creationDate: AnimatedAcrossShapes.date)
                    
                    MenuItem(view: AnyView(RotatingGrid()),
                             title: RotatingGrid.name,
                             creationDate: RotatingGrid.date)

                }
            }
            .navigationBarTitle("My Sketches", displayMode: .inline)
        } else {
            Text("iOS 14 Fallback view")
        }
    }
}

struct MySketchesMenu_Previews: PreviewProvider {
    static var previews: some View {
        MySketchesMenu()
    }
}
